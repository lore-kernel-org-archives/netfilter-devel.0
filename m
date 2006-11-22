From: Glen Turner <glen.turner@aarnet.edu.au>
Subject: Re: new code; iptables-xml for iptables package.
Date: Thu, 23 Nov 2006 04:07:58 +1030
Message-ID: <45648AF6.30005@aarnet.edu.au>
References: <455311B5.5000600@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <455311B5.5000600@ufomechanic.net>
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

Amin Azez wrote:

> A sample of the xml format
> <iptables-rules>
>   <table name="mangle" >
>     <chain name="PREROUTING" policy="ACCEPT" packet-count="63436"
> byte-count="7137573" >
>       <rule >
>        <conditions>
>         <match >
>           <p >tcp</p>
>         </match>
>         <tcp >
>           <sport >8443</sport>
>         </tcp>
>        </conditions>
>        <actions>
>         <call >
>           <check_ip />
>         </call>
>        </actions>
>       </rule>
>     </chain>
> </iptables-rules>

Folks,

Before committing stuff which generates XML output it might be
worthwhile checking if a DTD has also been supplied so that
third-party tools can use and generate the XML with some
assurance.  If the use of the XML is private to Netfilter
then then XML format offers no advantages over the standard
format.

In particular, folks will want something to use as a target
when converting to/from Tivoli XML/Juniper XML/Cisco XML/
OASIS XACML/IETF PCM (as you can see there's no shortage of
XML ACL formats, and still no real standardisation in sight
despite consistent ACLs between devices being a boon to network
operations).

Thanks, Glen

-- 
  Glen Turner         Tel: (08) 8303 3936 or +61 8 8303 3936
  Australia's Academic & Research Network  www.aarnet.edu.au
