From: Francesco Sportolari <francesco@unipg.it>
Subject: Re: [PATCH] New behaviour for early_drop()
Date: Mon, 14 Apr 2003 15:40:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200304141540.30996.francesco@unipg.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Monday 14 April 2003 13:06, Patrick Schaaf wrote:
> Hi Francesco,
>
> I have some comments. First, thanks for taking the effort to implement
> this idea.  Regarding space overhead, it's 8 byte (two 4-byte pointers)
> for the struct list_head, not 2 byte. By itself, that's still acceptabl=
e.

Yeah, you're right, my fault... it's two pointers, so 8 bytes :)

> However, the additional locking (cross-CPU) will have an impact on
> high packet load performance. The traditional early_drop does not
> influence normal (nondropping case) operation in any way, so that's
> a new, additional serialization. I feel that's reason enough to make
> the whole thing optional, in some way.

I'm going to try this patch on a very busy firewall machine (dual Power3
IBM RS/6000), then i can give you some hints on the performance differenc=
e...
I agree with you that this serialization introduces delay in the processi=
ng
queue of the packet, but it can be good anyway.

> Finally, a stylistic comment, also directed at the other developers her=
e:
> you add a list_pop() macro to the netfilter listhelp.h file. I notice
> that about half the macros in that file are written in BIG_LETTERS(),
> the rest is small_caps(). Why this variance? I cannot see any system!

I've only followed the style used for list_append() and list_del()... How=
ever
i think that for the inline functions is acceptable to use low case.

> best regards
>   Patrick

Ciao,

-- Francesco
