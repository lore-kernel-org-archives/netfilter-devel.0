From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: Netfilter logging from the kernel
Date: Fri, 16 Jul 2004 00:10:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40F700BD.3090900@drugphish.ch>
References: <20040714132128.A30620@sphinx.mythic-beasts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: chris@dubfire.net
In-Reply-To: <20040714132128.A30620@sphinx.mythic-beasts.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

> We're interested in locking down machines, in an attempt to
> limit what a hacker can do if he is able to break into them.

 From your description I'd have to say two things:

o wrong mailinglist
o wrong approach

since this sounds very cocky let's see if I maybe misunderstand something.

> All of these machines will have a iptables firewall in place,
> limiting the outbound traffic.
> 
> Thus, the first thing an attacker would do after breaking in
> would be to attempt to remove the firewall rules.

Not necessarily. You might as well just install a backdoor lkm which 
happily coexists with your fw rules but kind of hijacks certain hooks.

> While we cannot defend against this, assuming he has gained root
> access, we would at least like to make the machine tamper evident.

That's why you should log everything; for example to a remote syslog 
server, or you could deploy leveraged-security systems like

o selinux
o rsbac
o write some lsm tracing hooks

> Initially, we thought that we could modify the iptables binary to
> print out something to syslog every time a change to the rules
> is made - however, it would be easy enough for the attacker to
> copy over a virgin copy of iptables.

Assuming that an intruder will change your firewall rules is the least 
of your concerns, really.

> Thus, the logging code must be in the kernel, and not in the
> iptables binary.

Or you use the cryptoAPI and digitally sign your rules in the kernel 
which would then be more ontopic for this list. Digsig is a project 
which has working code for signing user space apps, their concept could 
be adapted to kernel space as well.

> We would ideally like to see a log message sent to the
> syslog every time an iptables rule is added/modified/removed.

Check out do_ipt_get_ctl, ipt_register_* and follow the code from there.

> Does anyone know if there is anything in place right now that
> would allow this?

IIRC your can simply enable the DEBUG_IP_FIREWALL_USER switch in 
../linux/net/ipv4/netfilter/ip_tables.c and watch your kernlog grow.

Basically this is your file to look at, plus you need to check out a few 
functions in ../linux/include/linux/netfilter_ipv4/ip_tables.h

> If nothing exists, how difficult would it be to whip something
> like this up?

It's pretty straightforward once you've looked at the code.

> Could you point me to the right part of the code
> where I'd need to add my additional functionality.

I hope I did, however I also hope that you're not going to do this for 
your customers.

Best regards,
Roberto Nibali, ratz
-- 
echo 
'[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
