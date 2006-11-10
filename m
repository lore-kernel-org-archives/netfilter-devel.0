From: Amin Azez <azez@ufomechanic.net>
Subject: Re: new code; iptables-xml for iptables package.
Date: Fri, 10 Nov 2006 15:13:41 +0000
Message-ID: <45549725.50408@ufomechanic.net>
References: <455311B5.5000600@ufomechanic.net> <45549023.40801@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <45549023.40801@netfilter.org>
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

* Pablo Neira Ayuso wrote, On 10/11/06 14:43:
> Amin Azez wrote:
>> (I hope these can be added to the standard iptables package)
>>
>> Here is iptables-xml based on iptables-restore (as it knows how to parse
>> iptables-save format), along with some xslt that converts back to
>> iptables-save format.
>>
>> A typical null use would be:
>>
>>   iptables-save -c | iptables-xml -c | xsltproc iptables.xslt -
> 
> Just a wild thought, why not go further and provide a native XML
> interface instead of a converter?

There are some considerations.

Small changes must be made to the save- output of every module.

If instead of using printf, a slightly more semantic function were used,
then we would get xml output nearly for-free.

Most modules would just output like this:

iptables_arg_output("source-address",souce_address,0);

which for xml output would be
<source-address>1.1.1.1</source-address>

or text output:

--source-address 1.1.1.1

(the final 0 is the invert flag, for matches).

However if iptables could save in xmlformat natively, then there is a
strong argment that it should be able to load xmlformat natively,
instead of using xsltproc or xsl converter of the day.
- nothing very wrong in this but it would be a bigger decision and one
which would be easier to make (and justify the time for) when we see how
this settles in.

> BTW, could you also provide a DTD (Document Type Definition)? It can be
> interesting to check for well-formed documents.

Yes.... it may require a new xml format as the current format is perhaps
too free-form, with each module or argument being converted directly to
a new tag. The disadvantage is that the DTD will depend on "knowing"
precisely which iptables modules are available.

Perhaps it's an advantage if the DTD were also generated as part of the
iptables build system, but it would then require that each module more
formally declare the semantics of the arguments in order to support such
generation.

In other words to do it that way is ideal but not a small change.

I would support working towards that.


I had toyed with output like:
<action type="SNAT"><arg name="source-address">1.1.1.1</arg></action>
but it was too sterile and void of meaning. Although it would be easy to
 FIX a DTD for it to verify against,the verification would mean very little.

If we keep to the current format and can generated a DTD at compile
time, then DTD verification would be quite meaningful.

Sam
