From: Andreas Schultz <aschultz@tpip.net>
Subject: Re: nft: parser problem, can use mark as datatype in sets and maps
Date: Tue, 11 Aug 2015 11:18:54 +0200
Message-ID: <55C9BDFE.9080207@tpip.net>
References: <1027218717.2766569.1439214492178.JavaMail.zimbra@tpip.net> <20150810170920.GA3487@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:36796 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933620AbbHKJS6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Aug 2015 05:18:58 -0400
In-Reply-To: <20150810170920.GA3487@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/10/2015 07:09 PM, Pablo Neira Ayuso wrote:
> On Mon, Aug 10, 2015 at 03:48:12PM +0200, Andreas Schultz wrote:
>> Hi,
>>
>> The data type definition for mark and the general idea of the parser
>> indicate that the following nft statements should work:
>>
>>    # nft add map filter MAP1 { type ipv4_addr : mark\; }
>>    # nft add set filter SET1 { type mark\; }
>>
>> However, both fail with a similar error message:
>>
>>    <cmdline>:1:40-43: Error: syntax error, unexpected mark, expecting string
>>    add map filter MAP1 { type ipv4_addr : mark; }
>>    <cmdline>:1:28-31: Error: syntax error, unexpected mark, expecting string
>>    add set filter SET1 { type mark; }
>>
>> The problem is parser, it expects a string as data type spec, but
>> mark is already declared as a token.
>>
>> I don't have much experience with bison, so does anyone have a quick
>> work-around for this?
>
> This is fixed by 2baf59c ("parser_bison: allow to use mark as datatype
> for maps and sets").

Ah, I was using the next-4.2 branch and missed this fix in master, sorry 
for the noise.

However, the parser problem is solved, but named mark maps are still
not working:

anonymous maps work as expected:

   # nft add rule ip mangle OUTPUT mark set ip saddr map {  192.168.0.10 
: 0x1 }

named maps do not:

   # nft add map mangle CLASS05 "{ type ipv4_addr : mark; }"
   # nft add element mangle CLASS05 { 192.168.0.10 : 0x1 }
   # nft add rule ip mangle OUTPUT mark set ip saddr map @CLASS05
   <cmdline>:1:1-56: Error: Could not process rule: Invalid argument

Any idea?

Andreas
