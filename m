From: Martijn Lievaart <netfilter-devel@rtij.nl>
Subject: Re: I don't understand what goes where, very confused about POM-ng
Date: Wed, 05 May 2004 20:00:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40992BB6.9030805@rtij.nl>
References: <4099210C.40309@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martijn Lievaart <netfilter-devel@rtij.nl>
In-Reply-To: <4099210C.40309@rtij.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Martijn Lievaart wrote:

> As an alternative, would it be possible to just create a 
> linux-2.6.patch file that applies after the 2.4 patch has applied? 
> This would be a good solution because many patches need only minor 
> modifications to newly added files (especially only ipt_xxx.c) to make 
> them run under 2.6.


Damn, that does not work. The test before applying fails because the new 
file is not there yet. Seems like a nice feature to add though, but that 
would require a lot of trickery I think.

Regards,
Martijn Lievaart
