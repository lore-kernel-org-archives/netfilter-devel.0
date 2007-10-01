From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: Netfilter callbacks and UDP fragmenting
Date: Mon, 1 Oct 2007 15:19:23 +0200
Message-ID: <20071001131921.GA16274@sch.bme.hu>
References: <004901c8041d$851a86d0$620aa8c0@nyala>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomas Mandys <tomas.mandys@2p.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:41623 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbXJANjS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Oct 2007 09:39:18 -0400
Content-Disposition: inline
In-Reply-To: <004901c8041d$851a86d0$620aa8c0@nyala>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On h, okt 01, 2007 at 01:23:40 +0200, Tomas Mandys wrote:
> are UDP packets defragmented before are passed to netfilter callback
> functions (e.g. PREROUTING) or developer has to create buffer and
> defragment by himself, to release memory when a fragment is missing,
> etc. - is there a working implementation/example? How about locally
> generated packets in OUTPUT callback? 
> 
> I've looked e.g. in nf_conntrack_sip.c and I can't see any extra
> defragmentation code even SIP message can be fragmented, especially SDP
> content.

Netfilter IPv4 connection tracking code defragments all IPv4 datagrams
before processing them. So if you have connection tracking loaded you
won't see fragments in your hook functions. If there's a chance that your
code will be used without connection tracking then you'll have to handle
fragments by yourself.

-- 
KOVACS Krisztian
