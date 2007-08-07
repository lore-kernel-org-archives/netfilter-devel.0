From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: RE: conntrack clarification
Date: Tue, 7 Aug 2007 14:00:27 +1000
Message-ID: <33307780.1501186459222169.JavaMail.root@localhost>
References: <3434740.221186389567173.JavaMail.root@localhost>	<24966838.281186390464437.JavaMail.root@localhost>	<Pine.LNX.4.64.0708061106240.1735@fbirervta.pbzchgretzou.qr>
	<8883276.421186396148778.JavaMail.root@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, 'Andrew Hall' <temp02@bluereef.com.au>,
	'Eric Leblond' <eric@inl.fr>
To: "'Krzysztof Oledzki'" <ole@ans.pl>,
	"'Jan Engelhardt'" <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <8883276.421186396148778.JavaMail.root@localhost>
Content-Language: en-au
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> Or:
> -p tcp -m conntrack --ctstate NEW ! --syn -j INVALID_NewTCP -m
> conntrack --ctstate ESTABLISHED,RELATED -j RETURN
> 
> And reset (--reject-with tcp-reset) such connections in INVALID_NewTCP
> with something like:
> iptables -A INVALID_NewTCP -p tcp -m limit --limit 6/s -j REJECT --
> reject-with tcp-reset iptables -A INVALID_NewTCP -j DROP
> 
> One may also simply set: sysctl net.netfilter.nf_conntrack_tcp_loose=0
> (or net.ipv4.netfilter.ip_conntrack_tcp_loose on old kernels) but then
> it is not possible to reset such connections so simply.
> 

Thanks for coming back to me but I still don't believe this is a rule issue
- I believe it's an order problem in that a conntrack flush event will not
clear conntrack (add) events that are currently pending/locked. The reason I
believe this is because if I don't keep a constant flow of data traversing
between the host and firewall over SSH (in other words I stop the 'top') and
then flush the conntrack table, the SSH connection is now dead and any
subsequent packets from the host are then dropped as there is no longer any
applied state for this connection. Try it yourself:

1. Setup the following rules:

-s host -m state --state new -j ACCEPT
-s host -m state --state established,related -j ACCEPT
Policy drop everything else

2. open an SSH connection from host to firewall

3. check that the connection is there:

tcp      6 431995 ESTABLISHED src=10.1.1.103 dst=10.1.1.107 sport=56438
dport=22 packets=20 bytes=2828 src=10.1.1.107 dst=10.1.1.103 sport=22
dport=56438 packets=17 bytes=2681 [ASSURED] mark=0 use=1

4. now remove the --state new rule

5. check that the connection is still there and a few 'ps' to make sure the
connection is still alive. It is. New connections are not allowed, but the
existing connection remains open and active.

6. now conntrack -F

7. the connection is removed from the conntrack table and the SSH session is
dead (which is what I expect)

Now try the same test again, while maintaining a constant flow of SSH data
between host and firewall. This time, the connection won't die and the
connection re-adds itself to the conntrack table. According to my logic, as
far as the firewall is aware, a connection is only "established and related"
if there is an associated entry for it in the conntrack table. If the entry
is explicitly removed, how can any subsequent packets still be classified as
"related", as there is nothing to relate the connection anymore.

I'm sorry if I'm missing something plainly obvious here, but the case in
point doesn't make sense unless there is some locking function that
reinserts the state back into the table BEFORE the flush has a chance to
commit the removal. 



"Blue Reef disclaimer: This electronic message transmission contains information that is confidential or privileged. The information is intended to be for the use of the individual or entity named above. If you are not the intended recipient, be aware that any disclosure, copying, distribution, or use of the contents of this information is prohibited. If you have received this transmission in error, please notify us by telephone immediately."

Scanned by Sonar. 
Date: 2007-08-07 14:00:21
From: temp02@bluereef.com.au
To: netfilter-devel@lists.netfilter.org
Mail id: challenge-64592217832
