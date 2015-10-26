From: "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Subject: Re: linux 3.4.43 : kernel crash at __nf_conntrack_confirm
Date: Mon, 26 Oct 2015 02:13:34 -0400
Message-ID: <20151026021334.7cc89262@playground>
References: <CAOxq_8PF91fpX9jYTgBbXnOVeVfSu3tytu-3P_Zr5OodGRoz+g@mail.gmail.com>
	<CAOxq_8Pt7VMwkV8+wdjS9vj=-L0L8Xxkd3Beit0zZN_oR6ixhw@mail.gmail.com>
	<20151018080702.GA14564@breakpoint.cc>
	<CAOxq_8P9Qgy5+qWNCHtbG8qJwfdKSO3ZiDWoQW_6BVS-+hcTRA@mail.gmail.com>
	<20151021211911.GD31323@breakpoint.cc>
	<CAOxq_8PLX_+w-7mfx1Agh+utogEiFWHSmEFd0Bax1LY6qbEN-w@mail.gmail.com>
	<20151022034232.58e5af7a@playground>
	<CAOxq_8PTLQGZ7WwMX8W0dmWW3+cMbv5BkocR3rsW=rNTfxXRjw@mail.gmail.com>
	<20151022223945.660a1838@playground>
	<CAOxq_8Nvo=0xs=TgdnHQFMJ8Qu_Q3rnqKAQaNyLCkzD5n_Kj=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from MAIL1.WPI.EDU ([130.215.36.91]:44742 "EHLO MAIL1.WPI.EDU"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbbJZGNi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Oct 2015 02:13:38 -0400
Received: from MAIL1.WPI.EDU (MAIL1.WPI.EDU [130.215.36.91])
	by MAIL1.WPI.EDU (8.15.1/8.15.1) with ESMTP id t9Q6DboX013710
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Oct 2015 02:13:37 -0400
Received: from MX3.WPI.EDU (mx3.wpi.edu [130.215.36.147])
	by MAIL1.WPI.EDU (8.15.1/8.15.1) with ESMTP id t9Q6DbTQ013707
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Oct 2015 02:13:37 -0400
Received: from ALUM.WPI.EDU (ALUM.WPI.EDU [130.215.36.126])
	by MX3.WPI.EDU (8.14.4/8.14.4) with ESMTP id t9Q6DZQj028689
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Oct 2015 02:13:36 -0400
	(envelope-from neal.p.murphy@alum.wpi.edu)
Received: from playground (c-71-57-197-109.hsd1.va.comcast.net [71.57.197.109])
	(authenticated authen=neal.p.murphy)
	by ALUM.WPI.EDU (8.15.1/8.15.1) with ESMTPSA id t9Q6DZcb014534
	(version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Oct 2015 02:13:35 -0400
In-Reply-To: <CAOxq_8Nvo=0xs=TgdnHQFMJ8Qu_Q3rnqKAQaNyLCkzD5n_Kj=g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 24 Oct 2015 11:28:55 -0700
Ani Sinha <ani@arista.com> wrote:

> I just sent out the patches for approval. Please have a look.

The patch seems to have applied cleanly to 3.4.110, and Smoothwall--with 3.4.110--built without trouble.

We'll run tests soon enough. Any ideas as to how to test this problem on an SMP system? I can set up a 2- to 6-core VM and have several thousand processes hammer the firewall. Just need a clue as to what triggers the problem.

N
