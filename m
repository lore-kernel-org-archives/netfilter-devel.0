From: Patrick McHardy <kaber@trash.net>
Subject: Re: Time match in mangle/POSTROUTING?
Date: Wed, 03 Dec 2003 02:16:54 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCD3986.8040206@trash.net>
References: <3FCD2AA1.6F5E0225@info-link.net> <3FCD305F.4040406@trash.net> <3FCD3306.50603@trash.net> <3FCD3475.D4D0A063@info-link.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
  fabrice@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
In-Reply-To: <3FCD3475.D4D0A063@info-link.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Brad Fisher wrote:

>Thanks for the input :)  I'll take a look at this and will send a patch if I
>can get it working.  BTW:  is there an easy way in the kernel to determine
>whether DST is in effect or not? 
>
No, this is done by libc.

Best regards,
Patrick

> I've noticed that the time match always seems
>to be based off standard time.  I'm not very familiar with the internals of the
>kernel...
>
>-Brad
>  
>
