From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [RFC] XML output for libnetfilter_conntrack
Date: Tue, 21 Nov 2006 16:01:42 +0000
Message-ID: <456322E6.4070901@ufomechanic.net>
References: <4563061F.4080904@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4563061F.4080904@netfilter.org>
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

* Pablo Neira Ayuso wrote, On 21/11/06 13:58:
> Hi,
> 
> I'm about to complete the new API for libnetfilter_conntrack, it
> includes the possibility to dump conntrack entries in XML besides of the
> classic output similar to the primitive /proc interface. An example of
> the XML layout is the following:
> 
> /*
>  * XML output sample:
>  *
>  * <conntrack>
>  * 	<tuple direction="original">
>  * 		<layer3 protonum="2" protoname="ipv4">
>  * 			<src>192.168.0.1</src>
>  * 			<dst>192.168.0.2</dst>

How about <layer3 protonum="2" protoname="ipv4" src="192.168.0.1"
dst="192.168.0.2"/>

- maybe even ditch proto from num and name, what else could it be?

If there could possibly be other attributes of src and dst I can see why
we might have seperate tags as shown here with the ip's as un-named text
nodes acting as a "default" attribute.

>  * 		</layer3>
>  * 		<layer4 protonum="16" protoname"udp">
>  * 			<sport>80</sport>
>  * 			<dport>56665</dport>
>  * 		</layer4>
>  * 	</tuple>
>  * 	<tuple direction="reply">
>  * 		<layer3 protonum="2" protoname="ipv4">
>  * 			<src>192.168.0.2</src>
>  * 			<dst>192.168.0.1</dst>
>  * 		</layer3>
>  * 		<layer4 protonum="16" protoname="udp">
>  * 			<sport>80</sport>
>  * 			<dport>56665</dport>
>  * 		</layer4>
>  * 	</tuple>
>  * 	<meta>
>  * 		<protocol>
>  * 			<tcp>
>  * 				<state>ESTABLISHED</state>

given that states may be per protocol and possibly complicated maybe
there is better reason to have a state tag than to have a src tag ?

>  * 			</tcp>
>  * 		</protocol>
>  * 		<timeout>100</timeout>
>  * 		<status><assured>yes</assured></status>
>  * 		<counters direction="original">
>  * 			<bytes>10</bytes>
>  * 			<packets>1</packets>

again, I'm for
<counters ... bytes="10" packets="1"/>

I also prefer to have the counters in the with tuple. This is perhaps
confused because the tuple contains contrack identification information
as well as connection properties against which the counters are
naturally associated.

On reflection, I think that the "tuple" nature of ip and ports is not
relevant to the xml representation IFF the xml representation is
supposed to abstract away the conntrack implementation.

>  * 		</counters>
>  * 		<counters direction="reply">
>  *			<bytes>5029</bytes>
>  * 			<packets>12</packets>
>  * 		</counters>
>  * 	</meta>
>  * </conntrack>
>  */
> 
> Comments welcome,
> 

I suggest an alternative compact version from which greater verboseness
might be justified.

<conntrack status="ASSURED" timeout="100">
  <flow direction="original"  | <original
                   packets="1" bytes="10">
    <layer2 number="0" name="eth" vlan="2"
            src="00:00:00:00:00:00" dst="00:00:00:00:00:00"/>
    <layer3 number="2" name="ipv4" src="192.168.0.1" dst="92.1.0.253"/>
    <layer4 number="16" name="udp" src="53" dst="53"/>
  </flow>                     | </original>
  <flow direction="reply"    | <reply
      ... etc
  </flow>                     | </reply>
</conntrack>

I realise that layer2 isn't part of the main conntrack but it is part of
my conntrack, so I put it in there. I guess at name and number for layer2.

Maybe sport and dport should be used for L4 and not src and dst again...??

Sam
