From: "Cremella, Gustavo" <gcremella@antel.com.uy>
Subject: Iptables Suggestions
Date: Fri, 21 Nov 2003 17:11:37 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <9D4BE90F90812E40B90C52C44D5F330901D76C48@sede-mail-01.net.in.iantel.com.uy>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello team.

I have been working with this great soft since a time, because I'm =
maintaining some firewalls at work.

My suggestion is to add to the iptables functionality the hability to =
add conditionaly a rule.

Example:

If you need to rerun a script, usually (as seen in lots of examples) you =
have to flush all rules and start again from scratch.=20
You can remove a rule if you know exactly its order within a chain, but =
this may be impossible in a firewall that loads and unload some =
forwarding rules dinamically like those used on cybers when enabling o =
disabling a machine from conecting to the internet.
So before to load a rule that just exists (and that rules become =
repeated perhaps many times) you need to do something like this:

RuleExist=3D$(iptables -L FORWARD -n | grep "dpt:80" | grep "$SOURCE_IP" =
| grep "$DEST_IP | grep -c 'ACCEPT')
# Does that rule exist?
if [ "$RuleExist" -eq '0' ]; then
	echo "Enabling $SOURCE_IP"
	iptables -A FORWARD -m tcp -p tcp -s $SOURCE_IP -d $DEST_IP --dport 80 =
-j ACCEPT
else
if [ "$RuleExist" -gt '1' ]; then
	echo "WARNING: Rule Exist Multiple times" #RuleExist > 1 time
	else echo "WARNING: Rule Exist" #RuleExist 1 time
fi
fi

(Similar way to remove a rule without having error messages if that rule =
does not exist yet.)

This is complex and has to be done with a lot of scripting line, for =
each rule you need to check before add, insert o delete into firewalling =
scripts that change rules dinamically all the time.
Perhaps a new command line option like -A or -I but conditional may be =
added into iptables syntax to work in this maner:
First check if a matching rule just exists (that rule may be more =
flexible an general) in the same chain an with the same target. If that =
rule exists, then appending or inserting conditionaly a rule that is =
matched by another one will not be inserted nor appended.

Syntax suggestion: iptables -AC FORWARD......., where AC is the command =
for Append Conditional if no existing rule also match that kind of =
packets in that chain and target.

Example:

Existing rules is:

iptables -t nat -A POSTROUTING -m tcp -p tcp -d 10.0.0.0/24 --dport 6666 =
-j MASQUERADE

Adding conditional this rule:

iptables -t nat -AC POSTROUTING -m tcp -p tcp -d 10.40.1.0/8 --dport =
6666 -j MASQUERADE

will not be appended, and no innecesary load of netfilter tables will =
occur since 10.40.1.0/8 is contained into 10.0.0.0/24 net and packets of =
existing rule just math this new one.

Another improvement may be, like naming user chains, an option to name =
rules (an ID_NAME field, then you can load or unload a rule simply =
specifing its "ID_NAME")

Examples:

iptables -A FORWARD -name "SSH_FW" -m tcp -p tcp -s "$SOURCE_IP" --dport =
22 -j ACCEPT

Then deleting this rule may be done with:

iptables -D FORWARD -name "SSH_FW"

You don't need to know its place nor specifing exactly the rule as it =
was loaded to be delete.

Thanks you all for your great job!!

Gustavo Cremella
