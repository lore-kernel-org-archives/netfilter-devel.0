From: Brad Chapman <kakadu_croc@yahoo.com>
Subject: Re: [NEW EXTENSION] Condition Match
Date: Tue, 29 Oct 2002 15:00:57 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021029230057.20079.qmail@web40906.mail.yahoo.com>
References: <3DBED94E.1030107@videotron.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephane Ouellette <ouellettes@videotron.ca>
In-Reply-To: <3DBED94E.1030107@videotron.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Mr. Oullette,

--- Stephane Ouellette <ouellettes@videotron.ca> wrote:
> Folks,
> 
>    I developped last week a new extension to Netfilter in order to 
> enable or disable a set of rules using /proc files.
> 
>    As an example, I like to play Quake III Aerna with a few friends of 
> mine but I don't want to keep the firewall rules that make them able to 
> connect to my computer active at all times.  Adding and removing these 
> specific rules is annoying...
> 
>     So my solution is illustrated by the following rules:
> 
> iptables -t nat -A PREROUTING -p udp -m condition -i $INTERNET --dport 
> 27960 --condition quake -j DNAT --to-destination $MYCOMPUTER
> iptables -t filter -A FORWARD -p udp -m condition -i $INTERNET -o $LAN 
> --dport 27960 --condition quake -j ACCEPT
> iptables -t filter -A FORWARD -p udp -m condition -i $LAN -o $INTERNET 
> --dport 27960 --condition quake -j ACCEPT
> 
> 
> To enable the rules, issue:        echo 1 > /proc/net/ipt_condition/quake
> To disable the rules, issue:       echo 0> /proc/net/ipt_condition/quake

Useful. I can think of dozens of different uses for soemthing like this.

> 
> 
> The /proc files are created automagically when a new condition is 
> defined and destroyed when no rule points to them anymore.
> 
> As of this writing, the condition match module supports only one 
> condition per rule.  I think I will add in a near future the possibility 
> to match on many conditions at the same time, using the syntax:     
> --condition file1,file2,file3. . .

IMO you should be careful here. Adding too many of these just clutters things up
and makes it hard to understand.

> 
> - It was tested under kernel 2.4.20-pre10-ac2
> - So far so good, the condition match module seems stable !
> 
> Any comments, bug reports or suggestions would be greatly appreciated.

One suggestion: take a look at iptables2 and code up a patch for this which uses
netlink to check&control the conditions. Also, try a patch for IPv6, IMHO.

> 
> Enjoy !
> 
> Stephane.
> 

Brad

=====
Brad Chapman

Permanent e-mail: kakadu_croc@yahoo.com

__________________________________________________
Do you Yahoo!?
HotJobs - Search new jobs daily now
http://hotjobs.yahoo.com/
