From: Giacomo <delleceste@gmail.com>
Subject: OUTPUT DNAT AND FILTERING - scenario
Date: Wed, 21 Feb 2007 11:55:51 +0100
Message-ID: <885896af0702210255s3f0485a5t7420a55e1b8cea45@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "netfilter devel" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Good morning to all.

These days i was thinking about this network scenario:


BROWSER WEB --> PROXY WEB --> INTERNET

1st scenario:

Suppose that the user wants to block connections towards the web site
x.y.z.w:80

and that the local nat is setup to redirect automatically all connections
to the port 80 towards the proxy_address:8080

iptables -t nat -A OUTPUT -j DNAT -p tcp --to PROXY_IP:8080

and the user wants to block the site x.y.z.w:80:

iptables -t filter -A OUTPUT -d x.y.z.w:80 -j DROP

This does not really block the traffic towards the x.y.z.w:80 service
because the FILTER is applied AFTER the address translation.

Instead the rule

iptables -t filter -A OUTPUT -d PROXY_IP:8080 -j DROP

blocks the traffic towards the proxy web, demonstrating that the
filter is applied
AFTER the DNAT translation.

I was wondering the reason why this kind of implementation: while it
could be useful
to drop the traffic towards some specific site/machine also if behind
a web proxy,
on the other side a workstation administrator would normally never insert a DNAT
OUTPUT rule to redirect connections to another address and at the same time
want to block the traffic in that new direction...

Another observation is the following.
If FILTERING was done BEFORE the OUTPUT DNAT an administrator could

1. block outgoing traffic towards a specific undesired address;
2. force each connection towards port 80 to be redirected to PROXY:8080
    with an OUTPUT DNAT rule
3. Guarantee that the unwanted connection be blocked inserting a DROP rule
    in OUTPUT chain towards the PROXY_IP:8080
    (i.e. one cannot tell his browser web to contact the proxy
directly to bypass
    the OUTPUT filter... since the check would be done BEFORE the OUTPUT DNAT)

Finally, my question is very simple:
why doues iptables apply the FILTER rules AFTER the OUTPUT DNAT and not
before, when the packet still has the original destination address?

Thanks a lot for any answer.

Giacomo Strangolino, Italy.







-- 
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

IPFIREwall (http://www.giacomos.it/ipfire) viene presentato
all'Universita` degli Studi di Udine, il 28 ottobre, in occasione del
Linux Day 2006:
http://iglu.cc.uniud.it/linuxday

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
