From: "James King" <t.james.king@gmail.com>
Subject: Re: [PATCH RFC] xt_layer7
Date: Mon, 6 Oct 2008 11:57:53 -0700
Message-ID: <38bcb3ec0810061157k14d15ae3h902265f42095b469@mail.gmail.com>
References: <38bcb3ec0810040022w79ccea3dk134c3f03d375a601@mail.gmail.com>
	 <alpine.LNX.1.10.0810040750300.19954@fbirervta.pbzchgretzou.qr>
	 <48E8C637.5060700@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Jan Engelhardt" <jengelh@medozas.de>,
	"Matthew Strait" <quadong@users.sourceforge.net>,
	"Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:28704 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbYJFS5z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 14:57:55 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1101241nfc.21
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Oct 2008 11:57:53 -0700 (PDT)
In-Reply-To: <48E8C637.5060700@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 5, 2008 at 6:50 AM, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>>
>> On Saturday 2008-10-04 03:22, James King wrote:
>>
>>> I've re-written xt_layer7 (l7-filter) so that it not longer requires
>>> patching of the nf_conn structure for data storage, using ct_extend
>>> instead, with the goal that it can eventually be used against a
>>> vanilla kernel with an unpatched iptables.
>>
>> Right now, you still cannot use it with a vanilla kernel because
>> patches like #3 you attached enlarges the allocated region (remember,
>> NF_CT_EXT_NUM just increased by one!), which is going to be a big
>> impact {for users not using all the extensions} {if every imaginable
>> extensions adds itself a NF_CT_EXT_ number}.

update_alloc_size() skips over unregistered extensions, and it's a bug
to pass (id == NULL) to nf_ct_ext_add() or nf_ct_ext_create(), so
unused extensions shouldn't really impact memory allocation in terms
of allocated region size.  Under patch #3, nf_cf_ext_types[] has a
single size increase by sizeof(nf_ct_ext_type), and it increases
ct->ext->offset by one u8 (so per-conntrack increase).  Is this size
increase alone enough to rule it out, or am I missing something else
here?

> I think I could agree to add something like a NF_CT_EXT_LIST
> extensions that wouldn't be used by mainline, but you could
> use it for xtables-addons. There's some padding in nf_ct_ext
> so it would (currently) not have any negative impact on mainline.
> I haven't spent much though on this so it might not work though.

If adding NF_CT_EXT_LAYER7 is a no-go, I could give this a try, but I
doubt I'd have a chance to get it done before the next merge window
closes (I was hoping to have this available for 2.6.28).  It would
have the same size increases noted above though, so there really
wouldn't be any difference between the two approaches (at least until
xt_layer7 is no longer the sole user).

How are the first two patches?  Layering the allocation inside of a
LIST extension would probably require them anyways.


Regards,
James
