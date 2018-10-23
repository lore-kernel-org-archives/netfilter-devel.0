From: Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH nf] netfilter: ipv6: fix oops when defragmenting locally
 generated fragments
Date: Tue, 23 Oct 2018 07:54:01 -0700
Message-ID: <CANn89iKvVNTXBsAV-3EwHaZiV7ZDxpqPM20acJx1t45iwdO1PQ@mail.gmail.com>
References: <CANP3RGeX5=c=Lb+Pkg89zD7zQ_Z1T8oPJRCkorNCdghmofYXxg@mail.gmail.com>
 <20181023144716.19746-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@vger.kernel.org,
        Lorenzo Colitti <lorenzo@google.com>,
        zenczykowski <zenczykowski@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181023144716.19746-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Oct 23, 2018 at 7:48 AM Florian Westphal <fw@strlen.de> wrote:
>
> Unlike ipv4 and normal ipv6 defrag, netfilter ipv6 defragmentation did
> not save/restore skb->dst.
>
> This causes oops when handling locally generated ipv6 fragments, as
> output path needs a valid dst.
>
> Reported-by: Maciej =C5=BBenczykowski <zenczykowski@gmail.com>
> Fixes: 84379c9afe01 ("netfilter: ipv6: nf_defrag: drop skb dst before que=
ueing")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Eric Dumazet <edumazet@google.com>
