From: Patrick McHardy <kaber@trash.net>
Subject: Re: new ipt_ACCOUNT version
Date: Wed, 09 Jun 2004 10:39:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40C6CCC1.5070405@trash.net>
References: <200405291527.43712.thomas.jarosch@intra2net.com> <40C493C4.2020700@trash.net> <200406072148.07628.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
In-Reply-To: <200406072148.07628.thomas.jarosch@intra2net.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thomas Jarosch wrote:
> Hi Patrick,
> 
> Thanks for the in-depth review! I was amazed you found
> the off-by-one "bug" in the netmask calculation code :-)
> 
> Attached is a new version with all the fixes.
> I did some more old-gcc-compile fixing.

Thanks, it looks ok, we can put it in CVS and do remaining
cleanup then. Can you send me a patch (including userspace)
for pom-ng ?

Regards
Patrick

> 
> Cheers,
> Thomas
> 
