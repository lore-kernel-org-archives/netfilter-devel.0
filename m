From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Launch script when packet is received
Date: Tue, 06 Mar 2007 12:53:24 +0000
Message-ID: <45ED6444.7020803@ufomechanic.net>
References: <1173135814.45eca1c605b17@webmail.alinto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: octane indice <octane@alinto.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1173135814.45eca1c605b17@webmail.alinto.com>
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

* octane indice wrote, On 05/03/07 23:03:
> Hello
> 
> Is there any way to do something like this:
> 
> iptables -A INPUT <packet> -j ACTION --script /sbin/myscript.sh
> 
> And better, with myscript.sh called with arguments like IP src or dest or
> protocol or type of packet?

err.... crikey!
The short answer is: Thankfully not.

The longer answer is yeee-ee-e-es.

You can either use -j LOG and fiddle with your syslog.conf file so that
the logged messages that match are written to a named pipe, and you have
a dispatch daemon that listens on the pipe (you can write this in bash)
and calls your scripts.

Or you could use the depracated ULOG v1 target which receives packets
over netlink and hack the ulog daemon to do your bidding launching scripts.

Or you could use the QUEUE target to queue whole packets to user space
and then use a perl NF QUEUE hander to do your work for you.

I'm sure you have an interesting reason for wanting to do it.

Just don't ask for shell script matches where the exit code of the shell
script is taken as the match result. Although you could probably do this
 using the NF QUEUE method you would also have bad dreams. Or something.

Sam
