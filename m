From: Patrick McHardy <kaber@trash.net>
Subject: Re: Having trouble building a new connection tracker helper module
Date: Wed, 09 Mar 2005 00:02:53 +0100
Message-ID: <422E2F1D.4010601@trash.net>
References: <8B888AAAAB0FD31189590008C79184432644807B@zbl6c002.corpeast.baynetworks.com>
	<422E2E7D.5040409@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Chad Goss <chgoss@nortel.com>
In-Reply-To: <422E2E7D.5040409@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
>>
>> But, I don't see any .ko, or .o or .mod.c files getting created... 
>> What step
>> am I missing?
> 
> 
> Kconfig. Without a config option, your Makefile addition will
> always evaluate to obj-n += ...

Actually its obj- += ... a warning from kbuild for these objects
might be useful.

Regards
Patrick
