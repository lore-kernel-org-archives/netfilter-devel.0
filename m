From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next v3 1/3] netfilter: nf_conntrack: push zone object
 into functions
Date: Thu, 30 Jul 2015 18:34:48 +0200
Message-ID: <55BA5228.6050908@iogearbox.net>
References: <cover.1437561897.git.daniel@iogearbox.net> <2f95183cf2520b93d8443be935372fbef3499b96.1437561897.git.daniel@iogearbox.net> <20150730160744.GA15008@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:54518 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbbG3Qey (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jul 2015 12:34:54 -0400
In-Reply-To: <20150730160744.GA15008@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/30/2015 06:07 PM, Pablo Neira Ayuso wrote:
> On Wed, Jul 22, 2015 at 12:54:46PM +0200, Daniel Borkmann wrote:
>> This patch replaces the zone id which is pushed down into functions
>> with the actual zone object. It's a bigger one-time change, but
>> needed for later on extending zones with a direction parameter, and
>> thus decoupling this additional information from all call-sites.
>>
>> No functional changes in this patch.
>>
>> The default zones becomes a global const object, namely nf_ct_zone_dflt
>> and will be returned directly in various cases, one being, when there's
>> f.e. no zoning support.
>
> Looks fine. This patchset depends on the recent fixes though, so let
> me send a pull request to David with pending nf-next updates, then you
> can rebase upon a fresh HEAD.

Okay, I guess there would be quite some ugly merge conflicts otherwise
due to the recent -nf fixes that accumulated over time. I will send out
a rebased version against -nf-next as soon as this dependency is resolved.

> Regarding follow up patches, it would be good if you rename CTA_DIR to
> CTA_ZONE_DIR. If you plan to place more information into the zone
> extension, then it's probably a good idea to add a new nested
> CTA_ZONE_INFO attribute where we can start adding new more information
> on the zone configuration there that applies to the tuple.

CTA_ZONE_DIR seems better, sure. I don't have any other extensions at
the moment, but it seems it makes sense to make this nested at this
point in time, so we have CTA_ZONE and CTA_ZONE_INFO as a container
for CTA_ZONE_DIR and whatever future might bring. I will look into it.

> I have seen also that you placed zone-dir= after use= in the sysctl
> output, but you can place this after the zone instead. We have a
> netlink interface so people should not be doing string parsing.

Okay, good to know, thanks!

> I'll make a closer look later to see if I have more comments. Thanks
> for your patience, Daniel.

No problem. Thanks, Pablo!
