From: "Ferry Huberts" <ferry@Hupie.com>
Subject: Re: Unique rule ID?!
Date: Mon, 8 Nov 2004 14:05:24 +0100 (CET)
Message-ID: <21865.217.169.232.210.1099919124.squirrel@217.169.232.210>
References: <418F52A5.7010700@anduras.de>
	<Pine.LNX.4.61.0411081255090.17672@filer.marasystems.com>
Reply-To: ferry@Hupie.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0411081255090.17672@filer.marasystems.com>
To: netfilter-devel@lists.netfilter.org
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

I also have a patch that implement a match 'userindex' that uses an integer.
Currently it uses a u_int16_t but this can easily be changed.
I am in the process of converting it to pom-ng format


Drop a mail if you would like to use it.

--
Ferry Huberts

> On Mon, 8 Nov 2004, Sven Anders wrote:
>
>> set with an unique id, it would be easy. Sadly, I did not found any
>> field in the netfilter rules structure to do this... I found an
>> 'comment' match extension, which I could misuse for it, but this would
>> be an hack.
>
> While the comment match is a hack it is actually designed for what you are
> looking for.
>
>> Or are there any unique identifiers to each rule (which would not change
>> from one kernel commit to the next) that I missed?
>
> No. Only rule number which you need to keep track of.
>
>> If I decide to add an ID field to the kernel's rule structure (and
>> implement the code for giving each new rule an unique ID), would you be
>> interested to accept these patch to the offical netfilter tree? If you
>> argue against it with the used memory, do you really think 2-4 bytes per
>> rule is too much? What is the biggest useful size of an netfilter table?
>> 1000 rules (= 4 Kbytes for IDs), 10000 rules (= 40KB)? If so much rules
>> are in place, don't you think you have to use chains? ;-)
>
> Unfortunately it is not possible to extend the structure without breaking
> compatibility, hence the existence of the comment match.
>
> Regards
> Henrik
>
