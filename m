From: Adrian Turcu <adrian.turcu@gmvinteractive.com>
Subject: Re: CONNMARK behaviour
Date: Fri, 15 Apr 2005 09:00:05 +0100
Message-ID: <200504150900.07990.adrian.turcu@gmvinteractive.com>
References: <200504141447.19432.adrian.turcu@gmvinteractive.com>
	<Pine.LNX.4.61.0504150220340.3687@filer.marasystems.com>
Reply-To: adrian.turcu@gmvinteractive.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0504150220340.3687@filer.marasystems.com>
Content-Disposition: inline
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

On Fri 15 Apr 2005 01:31, Henrik Nordstrom wrote:
> On Thu, 14 Apr 2005, Adrian Turcu wrote:
> >>
> >> # create a class: 6550x
> >> /sbin/iptables -t mangle -N class_6550x
> >> /sbin/iptables -t mangle -A PREROUTING -i eth1 \
> >> 	-d 192.168.1.218/255.255.255.255 -j class_6550x
> >> # mark the traffic matching this class and return
> >> # class 65501 (section 2)
> >> /sbin/iptables -t mangle -A class_6550x -j CONNMARK --set-mark
> >> 0xFFDD/0xFFFF /sbin/iptables -t mangle -A class_6550x -j RETURN
>
> You are missing to set the packet mark here. Only the connection mark is
> set by the above CONNMARK --set-mark .... You either need a MARK or
> CONNMARK --restore-mark to set the packet mark on these packets.

If I got it right, what you are saying is that the above class_6550x rules 
should be similar with these:

# mark the traffic matching this class
# class 65501 (section 2)
/sbin/iptables -t mangle -A class_6550x -j CONNMARK --set-mark
	0xFFDD/0xFFFF
#
# then save the conn mark to the packet mark, right?
#    and there is no need for a --save-mark line, correct?
/sbin/iptables -t mangle -A class_6550x -j CONNMARK --restore-mark
#
# then return to the parent
/sbin/iptables -t mangle -A class_6550x -j RETURN


So, if the above is correct, instead of using the combination --set-mark (by 
MARK) then --save-mark (by CONNMARK), one can use --set-mark and 
--restore-mark (both by CONNMARK) in this very order to save the mark for the 
connection packet? Am I correct assuming this?
I'm not able to reproduce this just now, but I'll make time later on.

Thanks for your kind reply Henrik,
Adrian
