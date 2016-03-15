From: Piyush Pangtey <gokuvsvegita@gmail.com>
Subject: Re: [PATCH v5] extensions: libxt_multiport: Add translation to nft
Date: Tue, 15 Mar 2016 09:09:14 +0530
Message-ID: <20160315033914.GA4783@fate>
References: <20160313084618.GA3913@fate>
 <20160315010604.GA23490@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34274 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbcCODjM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 23:39:12 -0400
Received: by mail-pf0-f196.google.com with SMTP id n5so852954pfn.1
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2016 20:39:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160315010604.GA23490@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 15, 2016 at 02:06:04AM +0100, Pablo Neira Ayuso wrote:
> On Sun, Mar 13, 2016 at 02:16:18PM +0530, Piyush Pangtey wrote:
> > Added full translation for multiport
> > 
> > Examples :
> > $ iptables-translate -A input -p tcp -m multiport --ports ssh:http -j ACCEPT
> > nft add rule ip filter input ip protocol tcp tcp dport ssh - http tcp sport ssh - http counter accept
> 
> --ports is not so easy to translate as this implies an 'or'. But what
> you expressed above is an 'and'.
> 
Ok

> So please return 0 for this case so we remember that we currently have
> no translation for this. Actually, I remember Shivani documented this
> on wiki.nftables.org.
> 
> > $ iptables-translate -A input -p sctp -m multiport --dports 11:18  -j ACCEPT
> > nft add rule ip filter input ip protocol sctp sctp dport 11 - 18 counter accept
> 
> Almost there.
> 
> Note that nft generates the dependencies for you, so you can simplify
> this translation above to:
> 
> $ iptables-translate -A input -p tcp -m multiport --dports ssh:http -j ACCEPT
> nft add rule ip filter input tcp dport 22-80 counter accept
> 
> > $ iptables-translate -A input -p dccp -m multiport --sports 11:18 -j ACCEPT
> > nft add rule ip filter input ip protocol dccp dccp sport 11 - 18 counter
> > accept
> 
> You can remove "ip protocol dccp".
> 
As per v1, I was concerned about this "ip protocol" , because it was not
introduced by libxt_multiport and so it may break others.
Arturo Borrero Gonzalez also suggested that translation should include 
"ip protocol" and "meta l4proto", which are redundant.

> > $ ip6tables-translate -A input -p udplite -m multiport --sports 11:18 -j ACCEPT
> > nft add rule ip6 filter input meta l4proto udplite udplite sport 11 - 18
> > counter accept
> 
> You can also remove "meta l4proto udplite".
> 
> Please, don't forget to test that nft accepts the syntax that you
> propose as translation.
> 
Ok . I always test translation before sending. :)

> Thanks.

-- 

With regards,
Piyush Pangtey <gokuvsvegita@gmail.com>
