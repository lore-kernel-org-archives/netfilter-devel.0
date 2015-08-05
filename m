From: Joe Stringer <joestringer@nicira.com>
Subject: Re: [PATCH net] netfilter: conntrack: Use flags in nf_ct_tmpl_alloc()
Date: Tue, 4 Aug 2015 18:38:00 -0700
Message-ID: <CANr6G5y9tYFs+QPwj9G4WyMiD3VryE_aQ3KDu5UZQm7kR6ugWQ@mail.gmail.com>
References: <1438738440-5320-1-git-send-email-joestringer@nicira.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438738440-5320-1-git-send-email-joestringer@nicira.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 4 August 2015 at 18:34, Joe Stringer <joestringer@nicira.com> wrote:
> The flags were ignored for this function when it was introduced. Also
> fix the style problem in kzalloc.
>
> Fixes: 0838aa7fc (netfilter: fix netns dependencies with conntrack
> templates)
> Signed-off-by: Joe Stringer <joestringer@nicira.com>

s/net/nf/ in subject line.
