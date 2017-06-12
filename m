From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH nf-next] netns: add and use net_ns_barrier
Date: Mon, 12 Jun 2017 14:47:50 -0700
Message-ID: <CAM_iQpXgrQcbrQsMVoomcsHtk4JffRjJ27FLRoignndAzFVkug@mail.gmail.com>
References: <20170530093812.10712-1-fw@strlen.de> <87y3tcj3n7.fsf@xmission.com>
 <20170601085259.GA6067@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        netfilter-devel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170601085259.GA6067@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 1, 2017 at 1:52 AM, Florian Westphal <fw@strlen.de> wrote:
> Joe described it nicely, problem is that after unload we may have
> conntracks that still have a nf_conn_help extension attached that
> has a pointer to a structure that resided in the (unloaded) module.

Why not hold a refcnt for its module?
