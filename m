From: 24 <24@k0n.org>
Subject: Re: detecting if compiled or loaded modules
Date: Sun, 15 Dec 2002 18:04:21 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021215180421.428269fb.24@k0n.org>
References: <20021215053701.15581.32963.Mailman@kashyyyk>
	<20021215133954.70ad328c.24@k0n.org>
	<3DFC447B.4090200@istitutocolli.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <3DFC447B.4090200@istitutocolli.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Greets,
  
     Useful indeed :) thanks! i just thought once the module is up or it's built in the kernel a file in /proc/sys/net/ipv4/* would appear but I think your suggestion would work thanks again

On Sun, 15 Dec 2002 09:59:39 +0100
Andrea Rossato <mailing_list@istitutocolli.org> wrote:

> there are probably better and more efficient ways, but:
> 
> /proc/modules gives you the list of loaded modules
> 
> you can check if a module was built into the kernel by checking its 
> functions in /boot/System.map
> for istance:
> cat /boot/System.map | grep hisax to check if hisax support was built 
> into the kernel (that will give you the list of related functions).
> 
> in /lib/modules/kernelversion/modules.dep you'll find a list of compiled 
> modules with their dependencies.
> 
> hope that this can be useful
> andrea
