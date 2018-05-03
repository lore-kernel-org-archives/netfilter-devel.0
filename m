From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Silently dropped UDP packets on kernel 4.14
Date: Thu, 3 May 2018 11:06:25 +0200
Message-ID: <CAKfDRXhkOb4eavm3y2ePwi6F6P59f=zEtQDOTjcvK4-s8WDhXQ@mail.gmail.com>
References: <CAKfDRXjop-G3qOZg+P6Mb4VKjvgJejScv9VHaJHB5OJBnqG30w@mail.gmail.com>
 <CAKfDRXj5oSD9-LKRbS_LYko+WEKwwunUq0L35G3t7Gi9Om74zw@mail.gmail.com>
 <20180501222406.fy5rph2t4dzndhu2@breakpoint.cc> <CAKfDRXhkXvF==6LQFOG3Rf4dH4QVVUxR=1cXZoM2FPQksGdxwg@mail.gmail.com>
 <CAKfDRXiO7qKHGLf5faSy7g_f1p9budJLXS9-uZWLPgyx3OAJbA@mail.gmail.com> <20180503050345.iyasach2ogf25dt3@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180503050345.iyasach2ogf25dt3@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Florian,

On Thu, May 3, 2018 at 7:03 AM, Florian Westphal <fw@strlen.de> wrote:
> I'm sorry for suggesting that.
>
> It doesn't work, because of NAT.
> NAT rewrites packet content and changes the reply tuple, but the tuples
> determine the hash insertion location.
>
> I don't know how to solve this problem.

No problem. This has anyway served as a good exercise for getting more
familiar with the conntrack/nat code in the kernel. I did some more
tests and I see that on my router (or routers actually), just
replacing the ct solves the issue. While not a perfect solution, the
situation is improved considerably. Do you think a patch where the ct
is replace would be acceptable, or would upstream rather wait for a
"proper" fix to this problem? When replacing the ct, it is at least
possible to work around the problem in userspace, while without
replacing ct we are stuck with the original entry.

BR,
Kristian
