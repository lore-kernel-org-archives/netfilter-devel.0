From: Daniel Drake <dsd@gentoo.org>
Subject: Re: 2.6.12 netfilter: local packets marked as invalid
Date: Tue, 12 Jul 2005 14:21:36 +0100
Message-ID: <42D3C3E0.6030103@gentoo.org>
References: <42CE86B5.2080705@gentoo.org> <42CE8E96.1040905@trash.net> <42CEA5E4.40009@gentoo.org> <42D3B063.3000207@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261319AbVGLNVf@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42D3B063.3000207@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> We decided to revert the responsible change because it caused problems
> in other areas as well. This patch should fix your problem.

Thanks, it works. If you decide to revisit this in the future, feel free to
send me a patch and I will help test it.

Daniel
