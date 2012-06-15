From: Deepak Jangid <deepak_jangid1987@yahoo.co.in>
Subject: Re: Regarding connection mappings to module data structures
Date: Fri, 15 Jun 2012 11:27:34 +0530
Message-ID: <741D0771-782B-4457-A774-EFB243F7E8B7@yahoo.co.in>
References: <1339654713.58676.YahooMailNeo@web193406.mail.sg3.yahoo.com> <20120614182750.GA10798@1984>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nm4.bullet.mail.bf1.yahoo.com ([98.139.212.163]:30405 "HELO
	nm4.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753023Ab2FOGCv convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jun 2012 02:02:51 -0400
In-Reply-To: <20120614182750.GA10798@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14-Jun-2012, at 23:57, Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Thu, Jun 14, 2012 at 02:18:33PM +0800, Deepak Jangid wrote:
>> Hello Netfilter team,
>>  
>> I am seeking an infrastructure for mapping
>> conntrack(struct nf_conn) to a module private data structure as a context for
>> every connection.
>> I could not find any such.
>>  
>> I can add the private info when I see a new connection.
>> conntrack destroy events can be caught to destroy the
>> private structure.
>> But the thing is there is no mechanism to store the
>> private info mapped to a connection. Either I will have to maintain
>> hash-tables, which is highly irrelevant, or edit the nf_conn which seems a
>> better way.
>>  
>> What I was thinking is to have a list_head or a pointer
>> to a structure in nf_conn which can handle such scenarios.
>>  
>> Does this seems generic ? Well yes there is
>> conntrack_extend, but it is not generic to be usable by other modules.
> 
> But my guess is that conntrack extensions is what you want. See
> net/netfilter/nf_conntrack_extend.c and
> net/netfilter/nf_conntrack_timestamp.c for one example.

Yes exactly, that is what I am talking about. But you see 
Struct nf_ct_ext_type .id is what bugging me. 
It is not generic i'll have to add an enum to use it.

What I am suggesting is that we should make it general registrable.

Well you asked, what I am trying to do is make an 7th layer application filter.

Best regards,
Deepak jangid