From: "Vitaly E. Lavrov" <lve@guap.ru>
Subject: Re: [RFC PATCH nf_conntrack_extend] new extensions without changes
 kernel source
Date: Sat, 02 Nov 2013 18:30:27 +0400
Message-ID: <52750C83.2010305@guap.ru>
References: <525EEAB7.4090901@guap.ru> <20131029122212.GA8019@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.guap.ru ([91.151.188.3]:11395 "EHLO ns1.guap.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab3KBOac (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Nov 2013 10:30:32 -0400
In-Reply-To: <20131029122212.GA8019@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 29.10.2013 16:22, Pablo Neira Ayuso wrote:
> Hi Vitaly,
>
> On Wed, Oct 16, 2013 at 11:36:23PM +0400, Vitaly E. Lavrov wrote:
>> How to add additional data to the conntrack? This is needed to
>> the implementation of ndpi-netfilter.
>>
>> Now it is possible to add data to a struct "nf_conn-> ext" through
>> nf_conntrack_extend, but it requires a change in the kernel code.
>>
>> I have developed a patch to register custom extensions in nf_conn->ext.
>> In the kernel configuration, you can specify the maximum number of additional
>> extensions (0..8). When registering a custom extension to specify an
>> additional unique identifier extension (u32). In the extension properties
>> seq_print added optional method to display data in "/proc/net/nf_conntrack".
>>
>> What lacks is in this patch?
> I'm reticent to get this extremely generic infrastructure into
> mainstream, we need to know more on the ndpi needs and discuss some
> generic infrastructure that most layer 7 implementation can benefit
> from.
There are two implementations of DPI: l7 filter and opendpi. Both extensions
use conntrack. To work they need: a pointer to its internal structure of the
conntrack and the release of internal structures at the close of CT.
All of these features are implemented in conntrack_extend, but the addition
of new data there requires a change in the kernel code (changing one line).
In conntrack_extend already has 7 add-ons. What cardinally change from 2 - 3
generic extensions?
> BTW, please try to avoid /proc interfaces, we try to run away from them
> if possible, using ctnetlink would be better.
/proc interface for backward compatibility only. This part of the patch can be discarded.

I ask again: what in the patch is made poorly or improperly but to use /proc/net/conntrack ?

