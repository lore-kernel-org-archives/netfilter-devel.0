From: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Subject: Re: nf_conntrack and nf_conntrack_ipv4 for RHEL5
Date: Mon, 23 Jul 2012 13:28:28 -0700
Message-ID: <CAAJpzgaKDoF3JePvbNC=G61LG0m+TUDj2SwPR_LfdAFjFTP6Mw@mail.gmail.com>
References: <CAAJpzgZH-x73UMtWTaHA=nRMQ1GE1wy451q5APNzi5UaxY4How@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43350 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab2GWU2t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:28:49 -0400
Received: by yenl2 with SMTP id l2so5932574yen.19
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jul 2012 13:28:48 -0700 (PDT)
In-Reply-To: <CAAJpzgZH-x73UMtWTaHA=nRMQ1GE1wy451q5APNzi5UaxY4How@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On ubuntu system, I set up net.netfilter.nf_conntrack_acct = 1 . This
variable became available after I loaded the module nf_conntrack.
After that I got packet count and packet size in the nacct file.
(nacct file generated through nacct plugin from ulogd)
To set the above variable available in RHEL5, I have to load the
module. But it seems RHEL5 does not come with nf_conntrack module
along with the kernel. Is there any way I can get the nacct data in
RHEL5 version?

Thanks & Regards,




On Mon, Jul 23, 2012 at 12:17 PM, Gomathivinayagam Muthuvinayagam
<sankarmail@gmail.com> wrote:
> I hope nf_conntrack and nf_conntrack_ipv4 are not available on RHEL5.
> Is it correct?
>
> Thanks & Regards,
