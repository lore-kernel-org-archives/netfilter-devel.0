From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Silently dropped UDP packets on kernel 4.14
Date: Thu, 3 May 2018 13:19:49 +0200
Message-ID: <CAKfDRXhW=pN+uMggpJqk2PPHGcEHhoRT-Dr_T-B_sNghRTNiow@mail.gmail.com>
References: <CAKfDRXjop-G3qOZg+P6Mb4VKjvgJejScv9VHaJHB5OJBnqG30w@mail.gmail.com>
 <CAKfDRXj5oSD9-LKRbS_LYko+WEKwwunUq0L35G3t7Gi9Om74zw@mail.gmail.com>
 <20180501222406.fy5rph2t4dzndhu2@breakpoint.cc> <CAKfDRXhkXvF==6LQFOG3Rf4dH4QVVUxR=1cXZoM2FPQksGdxwg@mail.gmail.com>
 <CAKfDRXiO7qKHGLf5faSy7g_f1p9budJLXS9-uZWLPgyx3OAJbA@mail.gmail.com>
 <20180503050345.iyasach2ogf25dt3@breakpoint.cc> <20180503094241.mfos3scewpct3dnu@unicorn.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
To: Michal Kubecek <mkubecek@suse.cz>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180503094241.mfos3scewpct3dnu@unicorn.suse.cz>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Michal,

Thanks for providing a nice summary of your experience when dealing
with this problem. Always nice to know that I am not alone :)

On Thu, May 3, 2018 at 11:42 AM, Michal Kubecek <mkubecek@suse.cz> wrote:
> One of the ideas I had was this:
>
>   - keep also unconfirmed conntracks in some data structure
>   - check new packets also against unconfirmed conntracks
>   - if it matches an unconfirmed conntrack, defer its processing
>     until that conntrack is either inserted or discarded

I was thinking about something along the same lines and came to the
same conclusion, it is a lot of hassle and work for a very special
case. I think that replacing the conntrack entry is a good compromise,
it improves on the current situation, and allows for the creation of
"perfect" solutions in user-space. For example, a user can keep track
of seen UDP flows, and then only release new packets belonging to the
same flow when the conntrack entry is created.

BR,
Kristian
