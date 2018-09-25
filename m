From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: bpfilter breaks IPT_SO_GET_INFO
Date: Tue, 25 Sep 2018 19:59:00 +0200
Message-ID: <CACT4Y+aGYtWnGcVPhriLZB8z-hMdZ+2u=na5GN4GvByL6w49Wg@mail.gmail.com>
References: <CACT4Y+YS55tk5xoPmscBXcgSbLrgWFSLAz1MUEjby0XT8eanmQ@mail.gmail.com>
 <20180919071847.GE3876@unicorn.suse.cz> <CACT4Y+bdzDe_LhQQh-eLapOg0ZsfXFRm2tjUbiAsgS-ObMvwBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Fabian Vogt <fvogt@suse.com>, Takashi Iwai <tiwai@suse.de>
To: Michal Kubecek <mkubecek@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+bdzDe_LhQQh-eLapOg0ZsfXFRm2tjUbiAsgS-ObMvwBg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Sep 19, 2018 at 10:29 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Wed, Sep 19, 2018 at 9:18 AM, Michal Kubecek <mkubecek@suse.cz> wrote:
>> On Mon, Sep 17, 2018 at 03:36:21PM +0200, Dmitry Vyukov wrote:
>>> Hi,
>>>
>>> I am having some problem with upstream kernel and bpfilter. The
>>> manifestation is that IPT_SO_GET_INFO on an ipv4 socket works, then
>>> something (that I can't fully localize but can reproduce) happens and
>>> then IPT_SO_GET_INFO starts permanently returning 256.
>> ...
>>> Now the litmus program always fails with:
>>>
>>> getsockopt(3, SOL_IP, 0x40 /* IP_??? */,
>>> "filter\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., [84])
>>> = 256
>>>
>>> I am currently on upstream commit
>>> 28619527b8a712590c93d0a9e24b4425b9376a8c, my .config is attached. I
>>> don't know what is bpfilter, I see it mentions some umh, if it
>>> requires some additional setup I don't it, i.e. I don't install any
>>> userspace modules/helpers.
>>
>> This looks similar to the fallback issue described here:
>>
>>   https://bugzilla.suse.com/show_bug.cgi?id=1106751#c1
>>
>> Unfortunately I didn't have time to look into it more closely yet.
>
> +Takashi
>
> But I already have CONFIG_BPFILTER_UMH=y in my config, so it does not
> help completely.
> Also in my case it is working initially, but breaks after I run the
> second program.


I've disabled CONFIG_BPFILTER for now, it causes too many failures.
https://github.com/google/syzkaller/commit/19a403430d8d5ae2472e16dab2f26ddd899cf552
