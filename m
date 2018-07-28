From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/18] xfrm: Add compat layer
Date: Sat, 28 Jul 2018 14:18:12 -0700 (PDT)
Message-ID: <20180728.141812.1026007723536955024.davem@davemloft.net>
References: <1532703111.2679.20.camel@arista.com>
        <CADhJOfam+cY8uD4XTGvZSEFQdAgTu49G6cg6c64NJoP3bNuBmw@mail.gmail.com>
        <1532795215.2679.27.camel@arista.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: nharold@google.com, fw@strlen.de, steffen.klassert@secunet.com,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        0x7f454c46@gmail.com, netdev@vger.kernel.org, luto@kernel.org,
        ard.biesheuvel@linaro.org, hpa@zytor.com, mingo@redhat.com,
        john.stultz@linaro.org, kirill.shutemov@linux.intel.com,
        oleg@redhat.com, sboyd@kernel.org, rostedt@goodmis.org,
        tglx@linutronix.de, x86@kernel.org, linux-efi@vger.kernel.org,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        mchehab+samsung@kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, eparis@redhat.com,
        kadlec@blackhole.kfki.hu, pablo@netfilter.org, paul@paul-moore.com,
        coreteam@netfilter.org, linux-audit@redhat.com,
        netfilter-devel@vger.kernel.org, fan.du@intel.com
To: dima@arista.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1532795215.2679.27.camel@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Dmitry Safonov <dima@arista.com>
Date: Sat, 28 Jul 2018 17:26:55 +0100

> Well, I think, I'll rework my patches set according to critics and
> separate compat xfrm layer. I've already a selftest to check that 32/64
> bit xfrm works - so the most time-taking part is done.

The way you've done the compat structures using __packed is only going
to work on x86, just FYI.

The "32-bit alignment for 64-bit objects" thing x86 has is very much
not universal amongst ABIs having 32-bit and 64-bit variants.
