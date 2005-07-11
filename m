From: Rafael Dreher <dreher@interage.com.br>
Subject: Re: Re: Unable to add rule on Chain with 28 characters.
Date: Mon, 11 Jul 2005 10:22:34 -0300
Message-ID: <42D2729A.2050509@interage.com.br>
References: <42CECD47.5050003@interage.com.br>
	<20050708195049.GA7221@bender.817west.com>
	<42CEDB7F.3060609@interage.com.br>
	<6.0.1.1.2.20050708131029.01f2b9a8@insight.ip3.com>
	<42D2701A.4030205@interage.com.br>
	<Pine.LNX.4.61.0507111514530.30100@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0507111514530.30100@yvahk01.tjqt.qr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

No, that's not the case. I'm still thinking that's a bug.

[root@ward] [10:18:30]
[~]#iptables -t nat -N 123456789012345678901234567890

[root@ward] [10:18:38]
[~]#iptables -t nat -A POSTROUTING -j 1234567890123456789012345678
iptables v1.3.2: Couldn't load target
`1234567890123456789012345678':/usr/local/lib/iptables/libipt_1234567890123456789012345678.so: cannot open shared object
file: No such file or directory

Try `iptables -h' or 'iptables --help' for more information.

[root@ward] [10:18:41]
[~]#

Any idea?

Thank 's

Jan Engelhardt wrote:
>>So, that's a BUG.
>>Why iptbles let me add a chain with 30 characters, if I can't use this chain?
>>
>>[root@ward] [10:07:54]
>>[~]#iptables -t nat -N 123456789012345678901234567890
>>
>>[root@ward] [10:08:05]
>>[~]#iptables -t nat -A POSTROUTING -j 123456789012345678901234567890
>>iptables: No chain/target/match by that name
> 
> 
> Try
>   iptables -t nat                -N 123456789012345678901234567890
>   iptables -t nat -A POSTROUTING -j 1234567890123456789012345678
> 
> (Maybe add a '9' to the last.) If that's the case, then this is not really a 
> bug, but some code silently truncates the -N request.
> 
> 
> 
> Jan Engelhardt

-- 
Rafael Dreher

-:: Red Hat Certified Engineer ::-
-:: Nr: 807303498507617 ::-
http://www.redhat.com/training/certification/verify
