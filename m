From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Silently dropped UDP packets on kernel 4.14
Date: Tue, 1 May 2018 20:58:09 +0200
Message-ID: <CAKfDRXj5oSD9-LKRbS_LYko+WEKwwunUq0L35G3t7Gi9Om74zw@mail.gmail.com>
References: <CAKfDRXjop-G3qOZg+P6Mb4VKjvgJejScv9VHaJHB5OJBnqG30w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAKfDRXjop-G3qOZg+P6Mb4VKjvgJejScv9VHaJHB5OJBnqG30w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, May 1, 2018 at 8:50 PM, Kristian Evensen
<kristian.evensen@gmail.com> wrote:
> Does anyone have any idea of what could be wrong, where I should look
> or other things I can try? I tried to space the requests out a bit in
> time (I inserted a sleep 1 between them), and then the problem went
> away.

I should learn to always go through everything one last time before
sending an email. First of all, I see that both requests are treated
as new. Second, on my router, new requests are sent to user space for
marking, which explains the large delay in processing. When removing
the NFQUEUE-rule + handling and marking statically, my problem goes
away and I get an answer for both packets.

However, I do have one question. In my application, both packets are
assigned the same mark. Shouldn't they then match the same conntrack
entry, or am I missing something since that seems not to be the case?

BR,
Kristian
