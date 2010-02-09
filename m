From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter 00/05: netfilter fixes
Date: Tue, 09 Feb 2010 18:33:17 +0100
Message-ID: <4B719C5D.9060402@trash.net>
References: <20100208171024.15522.8136.sendpatchset@x2.localnet> <20100208.111517.197143656.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20100208.111517.197143656.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Mon,  8 Feb 2010 18:10:26 +0100 (MET)
> 
>> Please apply or pull from:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git master
>>
>> Please note: I forgot to add "Cc: stable@kernel.org" to two of these
>> patches and manually added it to the patch files, so I'd appreciate
>> if you could apply the patches manually instead of pulling from the
>> git tree this time.
> 
> Ok, I'll apply these by hand.

Thanks Dave. I plan to submit a first batch of patches queued for
net-next-2.6 soon, however these fixes introduced a large number
of conflicts. If you could merge net-2.6 into net-next-2.6 I'll
resolve them and send a pull request.

Thanks!

