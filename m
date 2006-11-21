From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [RFC] XML output for libnetfilter_conntrack
Date: Tue, 21 Nov 2006 16:46:22 +0000
Message-ID: <45632D5E.2020102@ufomechanic.net>
References: <4563061F.4080904@netfilter.org> <456322E6.4070901@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <456322E6.4070901@ufomechanic.net>
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

* Amin Azez wrote, On 21/11/06 16:01:

> I suggest an alternative compact version from which greater verboseness
> might be justified.
> 
> <conntrack status="ASSURED" timeout="100">
>   <flow direction="original"  | <original
>                    packets="1" bytes="10">
>     <layer2 number="0" name="eth" vlan="2"
>             src="00:00:00:00:00:00" dst="00:00:00:00:00:00"/>
>     <layer3 number="2" name="ipv4" src="192.168.0.1" dst="92.1.0.253"/>
>     <layer4 number="16" name="udp" src="53" dst="53"/>
>   </flow>                     | </original>
>   <flow direction="reply"    | <reply
>       ... etc
>   </flow>                     | </reply>
> </conntrack>
> 
> I realise that layer2 isn't part of the main conntrack but it is part of
> my conntrack, so I put it in there. I guess at name and number for layer2.
> 
> Maybe sport and dport should be used for L4 and not src and dst again...??

We should include a timestamp and (short-term-unique) conntrack-id in
that, and maybe even a created time if we keep it (I can't remember now):

 <conntrack ctid="1378654" created="102837453" time="102837459"
timeout="100" status="ASSUERED">

Sam
