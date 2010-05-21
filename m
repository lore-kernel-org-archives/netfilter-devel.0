From: Simon Lodal <simonl@parknet.dk>
Subject: Re: Any Performance benchmark on a Million conntracks
Date: Fri, 21 May 2010 16:05:47 +0200
Message-ID: <201005211605.48047.simonl@parknet.dk>
References: <AANLkTinGFeinOo2LfMU_6jcNewuFxXkZL1f9vAE-SXBe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Anand Raj Manickam <anandrm@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cuda.parknet.dk ([84.238.112.40]:44019 "EHLO cuda.parknet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884Ab0EUOFv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 May 2010 10:05:51 -0400
In-Reply-To: <AANLkTinGFeinOo2LfMU_6jcNewuFxXkZL1f9vAE-SXBe@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


FWIW, the load on my routers is regularly 400k conns, 5k inserts + 5k deletes, 
and 280 kpps traffic (140 kpps in each direction). There are certain scalability 
issues that I am investigating, but they do not seem related to conntracking 
at all.

I have configured for 8 million entries (2m buckets).

Torsdag 20 maj 2010 14:51:45 skrev Anand Raj Manickam:
> Hi,
> Is there any performance bench mark on conntrack response to 1 million
> conntrack entries in the conntrack table.
> Since conntrack uses Hashing to lookup the entries i had some doubts
> on the scalability. Can someone shed some light please?
> Thanks,
> Anand
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

