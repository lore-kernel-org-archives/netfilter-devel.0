From: Kenneth Porter <shiva@sewingwitch.com>
Subject: Re: Discrete packaging of experimental modules
Date: Sat, 18 Sep 2004 14:55:42 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <BB3C25FF8798E8E693A13041@[10.0.0.4]>
References: <0D0567C424F9F491BBAACF88@[10.169.6.246]>
	<Pine.LNX.4.61.0409181842420.17139@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0409181842420.17139@filer.marasystems.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

--On Saturday, September 18, 2004 6:45 PM +0200 Henrik Nordstrom 
<hno@marasystems.com> wrote:

> Extensions which is self-contained (header + c file, no patching of other
> files) can be compiled outside of the kernel just as any other kernel
> module, but there is no infrastructure in the netfilter project for doing
> this kind of out-of-kernel module builds and how to do this is left as an
> excersise to the reader.

Oh, good, thanks.

> Please note that you also need to build the userspace extension object.

Expected, hence my question/suggestion about making the extensions 
dynamically loadable. For instance, it would be nice if an extension could 
drop its userspace into, say, /usr/libexec/netfilter/xxx.so and be 
instantly recognized. One could then release a kernel-matched rpm or deb 
with the kernel module and the userspace component for the extension.
