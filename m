From: Amin Azez <azez@ufomechanic.net>
Subject: Re: new code; iptables-xml for iptables package.
Date: Thu, 23 Nov 2006 12:55:36 +0000
Message-ID: <45659A48.1060303@ufomechanic.net>
References: <455311B5.5000600@ufomechanic.net> <45648AF6.30005@aarnet.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <45648AF6.30005@aarnet.edu.au>
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

* Glen Turner wrote, On 22/11/06 17:37:
> Amin Azez wrote:
> 
>> A sample of the xml format
>> <iptables-rules>
>>   <table name="mangle" >
>>     <chain name="PREROUTING" policy="ACCEPT" packet-count="63436"
>> byte-count="7137573" >
>>       <rule >
>>        <conditions>
>>         <match >
>>           <p >tcp</p>
>>         </match>
>>         <tcp >
>>           <sport >8443</sport>
>>         </tcp>
>>        </conditions>
>>        <actions>
>>         <call >
>>           <check_ip />
>>         </call>
>>        </actions>
>>       </rule>
>>     </chain>
>> </iptables-rules>
> 
> Folks,
> 
> Before committing stuff which generates XML output it might be
> worthwhile checking if a DTD has also been supplied so that
> third-party tools can use and generate the XML with some
> assurance.  If the use of the XML is private to Netfilter
> then then XML format offers no advantages over the standard
> format.

Well it does offer advantages over the standard format, in that any xslt
processor can manipulate the rules as opposed to er.... sed and grep...
and perl...

> In particular, folks will want something to use as a target
> when converting to/from Tivoli XML/Juniper XML/Cisco XML/
> OASIS XACML/IETF PCM 

A DTD would help there, but this is -devel and you are looking at a new
work, in progress. Useful suggestions such as you have made were
anticipated when the xml stuff was offered. Thanks for this suggestion.

There has been discussion in this thread covering how a DTD might be
generated as part of the build process. It would require the
author/maintainer of each module to express semantically the arguments
they parse. No doubt this would have re-factorable benefits for the
options parsing which may be useful tool. In short, the work involved is
significant and would requires significant changes, and it is perhaps
better to see how useful the current format is, in order to get
direction for what should come next.

I would be interested to hear what use you are able to make of this xml
format and stylesheet. If you are familiar with iptables rules then lack
of a DTD should not be a practical obstacle.

> (as you can see there's no shortage of
> XML ACL formats, and still no real standardisation in sight
> despite consistent ACLs between devices being a boon to network
> operations).

Yeah; I don't think standardization of XML formats is desirable, each
format is expressive to it's purpose. XML allows recipe based conversion
between formats in many cases, or specific generation from a single
general purpose abstract format.

As the first part of a work in progress tools have been supplied to
convert between an iptables biased xml format and iptables native form.
I'm using these tools heavily (as might be expected) and find them
extremely useful.

I hope for feedback from others; no doubt I have to write a man page next.

Sam
