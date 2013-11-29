From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [RFC nftables kernel PATCH] netfilter: nf_tables: fix nft_meta_target
 module
Date: Fri, 29 Nov 2013 07:52:18 +0200
Message-ID: <52982B92.3040506@linux.intel.com>
References: <20131128111557.6154.40370.stgit@nfdev.cica.es> <5297382F.60707@linux.intel.com> <CAOkSjBj+XER8sn1eakaTDyDJPUn=t50WFYLE8zF4uP7Ef9TTOA@mail.gmail.com> <529745ED.5050201@linux.intel.com> <CAOkSjBjwCu3qPey44C3i95-GgUk2a5cwj6dzLwH5HjayDYFXwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59709 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab3K2FwV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Nov 2013 00:52:21 -0500
In-Reply-To: <CAOkSjBjwCu3qPey44C3i95-GgUk2a5cwj6dzLwH5HjayDYFXwQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

> Sounds reasonable. Then we can kill the nft_meta_targe.c file.

Actually no, just a small update on it (+nf_tables.h) and that's it. :)

Tomasz
