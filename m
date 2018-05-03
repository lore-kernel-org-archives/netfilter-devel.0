From: Florian Westphal <fw@strlen.de>
Subject: Re: Silently dropped UDP packets on kernel 4.14
Date: Thu, 3 May 2018 07:03:45 +0200
Message-ID: <20180503050345.iyasach2ogf25dt3@breakpoint.cc>
References: <CAKfDRXjop-G3qOZg+P6Mb4VKjvgJejScv9VHaJHB5OJBnqG30w@mail.gmail.com>
 <CAKfDRXj5oSD9-LKRbS_LYko+WEKwwunUq0L35G3t7Gi9Om74zw@mail.gmail.com>
 <20180501222406.fy5rph2t4dzndhu2@breakpoint.cc>
 <CAKfDRXhkXvF==6LQFOG3Rf4dH4QVVUxR=1cXZoM2FPQksGdxwg@mail.gmail.com>
 <CAKfDRXiO7qKHGLf5faSy7g_f1p9budJLXS9-uZWLPgyx3OAJbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKfDRXiO7qKHGLf5faSy7g_f1p9budJLXS9-uZWLPgyx3OAJbA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Kristian Evensen <kristian.evensen@gmail.com> wrote:
> I went for the early-insert approached and have patched

I'm sorry for suggesting that.

It doesn't work, because of NAT.
NAT rewrites packet content and changes the reply tuple, but the tuples
determine the hash insertion location.

I don't know how to solve this problem.
