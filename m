From: Pravin Shedge <pravin.shedge4linux@gmail.com>
Subject: Re: [PATCH 27/45] net: remove duplicate includes
Date: Sun, 10 Dec 2017 23:30:21 +0530
Message-ID: <CALSsfODmhEai9JhF_DmOMGnnf6CtjNohoJxWhFxwxddTE0yXkw@mail.gmail.com>
References: <1512581578-6216-1-git-send-email-pravin.shedge4linux@gmail.com> <20171206.155830.1524390600502175582.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        fw@strlen.de, Andrew Lunn <andrew@lunn.ch>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171206.155830.1524390600502175582.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Dec 7, 2017 at 2:28 AM, David Miller <davem@davemloft.net> wrote:
> From: Pravin Shedge <pravin.shedge4linux@gmail.com>
> Date: Wed,  6 Dec 2017 23:02:58 +0530
>
>> These duplicate includes have been found with scripts/checkincludes.pl but
>> they have been removed manually to avoid removing false positives.
>>
>> Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>
>
> Networking patches need to be sent to netdev@vger.kernel.org
>
> Thank you.

-- Adding netdev@vger.kernel.org for reviewing networking patches.

- Thanks & Regards,
    PraviN
