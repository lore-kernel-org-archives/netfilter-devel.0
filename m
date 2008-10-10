From: Patrick McHardy <kaber@trash.net>
Subject: Re: WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89 nf_nat_fn+0x33/0x155()
Date: Fri, 10 Oct 2008 15:52:49 +0200
Message-ID: <48EF5E31.1070606@trash.net>
References: <9b2db90b0810092324o729e29c0i2e654c812592bbd2@mail.gmail.com> <48EF5DF5.7070708@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Nir Tzachar <nir.tzachar@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760153AbYJJNxG@vger.kernel.org>
In-Reply-To: <48EF5DF5.7070708@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Nir Tzachar wrote:
>> Hello.
>>
>> The following warning is reproducible with the code below on 2.6.25.6,
>> which uses sendmsg on a udp socket using two iovecs:
>>
>> ....
>> And I always get  the following warning twice:
>>
>> [ 6658.338116] ------------[ cut here ]------------
>> [ 6658.338121] WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89
>> nf_nat_fn+0x33/0x155()
> 
> Thanks for the report. Does this patch fix it?

Actually, this can't be it. Let me look again.
