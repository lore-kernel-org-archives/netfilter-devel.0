From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Silently dropped UDP packets on kernel 4.14
Date: Wed, 2 May 2018 00:42:52 +0200
Message-ID: <CAKfDRXhkXvF==6LQFOG3Rf4dH4QVVUxR=1cXZoM2FPQksGdxwg@mail.gmail.com>
References: <CAKfDRXjop-G3qOZg+P6Mb4VKjvgJejScv9VHaJHB5OJBnqG30w@mail.gmail.com>
 <CAKfDRXj5oSD9-LKRbS_LYko+WEKwwunUq0L35G3t7Gi9Om74zw@mail.gmail.com> <20180501222406.fy5rph2t4dzndhu2@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180501222406.fy5rph2t4dzndhu2@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

Thanks for your quick and detailed reply!

On Wed, May 2, 2018 at 12:24 AM, Florian Westphal <fw@strlen.de> wrote:
> I'm not sure what the best way to solve this is, we either need
> to insert earlier in nfqueue case, or do conflict resolution in nfqueue
> case (and perhaps also nat undo? not sure).

My knowledge of the conntrack/nat subsystem is not that great, and I
don't know the implications of what I am about to suggest. However,
considering that the two packets represent the same flow, wouldn't it
be possible to apply the existing nat-mapping to the second packet,
and then let the second packet pass?

BR,
Kristian
