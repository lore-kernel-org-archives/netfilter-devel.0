From: Michal Kubecek <mkubecek@suse.cz>
Subject: Re: bpfilter breaks IPT_SO_GET_INFO
Date: Wed, 19 Sep 2018 09:18:47 +0200
Message-ID: <20180919071847.GE3876@unicorn.suse.cz>
References: <CACT4Y+YS55tk5xoPmscBXcgSbLrgWFSLAz1MUEjby0XT8eanmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>,
        netfilter-devel@vger.kernel.org, Fabian Vogt <fvogt@suse.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+YS55tk5xoPmscBXcgSbLrgWFSLAz1MUEjby0XT8eanmQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Sep 17, 2018 at 03:36:21PM +0200, Dmitry Vyukov wrote:
> Hi,
> 
> I am having some problem with upstream kernel and bpfilter. The
> manifestation is that IPT_SO_GET_INFO on an ipv4 socket works, then
> something (that I can't fully localize but can reproduce) happens and
> then IPT_SO_GET_INFO starts permanently returning 256.
...
> Now the litmus program always fails with:
> 
> getsockopt(3, SOL_IP, 0x40 /* IP_??? */,
> "filter\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., [84])
> = 256
> 
> I am currently on upstream commit
> 28619527b8a712590c93d0a9e24b4425b9376a8c, my .config is attached. I
> don't know what is bpfilter, I see it mentions some umh, if it
> requires some additional setup I don't it, i.e. I don't install any
> userspace modules/helpers.

This looks similar to the fallback issue described here:

  https://bugzilla.suse.com/show_bug.cgi?id=1106751#c1

Unfortunately I didn't have time to look into it more closely yet.

Michal Kubecek
