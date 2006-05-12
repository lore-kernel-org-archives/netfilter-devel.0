From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH] fix mem-leak in netfilter
Date: Fri, 12 May 2006 13:09:45 +0200
Message-ID: <9a8748490605120409x3851ca4fn14fc9c52500701e4@mail.gmail.com>
References: <20060507093640.GF11191@w.ods.org>
	 <egts52hm2epfu4g1b9kqkm4s9cdiv3tvt9@4ax.com>
	 <20060508050748.GA11495@w.ods.org>
	 <20060507.224339.48487003.davem@davemloft.net>
	 <44643BFD.3040708@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Cc: "David S. Miller" <davem@davemloft.net>, willy@w.ods.org,
	sfrost@snowman.net, gcoady.lk@gmail.com, laforge@netfilter.org,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	marcelo@kvack.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751208AbWELLLF@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
In-Reply-To: <44643BFD.3040708@trash.net>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 5/12/06, Patrick McHardy <kaber@trash.net> wrote:
> David S. Miller wrote:
> > From: Willy Tarreau <willy@w.ods.org>
> > Date: Mon, 8 May 2006 07:07:48 +0200
> >
> >
> >>I wonder how such unmaintainable code has been merged in the first
> >>place. Obviously, Davem has never seen it !
> >
> >
> > Oh I've seen ipt_recent.c, it's one huge pile of trash
> > that needs to be rewritten.  It has all sorts of problems.
> >
> > This is well understood on the netfilter-devel list and
> > I am to understand that someone has taken up the task to
> > finally rewrite the thing.
>
>
> I haven't seen any cleanup patches so far, so I think I'm
> going to start my nth try at cleaning up this mess.
> Unfortunately its even immune to Lindent ..
>

If you get too fed up with it, let me know, and I'll give it a go as well.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
