From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.4.23 masquerading broken?
Date: Wed, 03 Dec 2003 00:32:01 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCD20F1.6090800@trash.net>
References: <20031202165653.GJ615@gaast.net> <3FCCCB02.5070203@trash.net> <20031202173358.GK615@gaast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wilmer van der Gaast <lintux@lintux.cx>
In-Reply-To: <20031202173358.GK615@gaast.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Wilmer van der Gaast wrote:

>Dec  2 16:42:57 tosca kernel: NET: 4 messages suppressed.
>Dec  2 16:42:57 tosca kernel: MASQUERADE: Route sent us somewhere else.
>
>And, well, it goes on like that. dmesg is full of messages like this.
>
>The packages seem to get lost completely. At least I don't see them
>going out on eth1 (where they should go to).
>
>  
>
It may be related to using advances routing features ..
Can you give information about the specific IPs ? Is it local traffic ?

Thanks,
Patrick
