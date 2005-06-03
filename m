From: Kenneth Porter <shiva@sewingwitch.com>
Subject: Re: Writing new Netfilter Modules
Date: Fri, 03 Jun 2005 01:45:37 -0700
Message-ID: <880E619C7638E6C7AC163BC7@[10.169.6.246]>
References: <6B6D4D4E2ED1D6119DB80000D11D813EB4CA6F@blns203e.bln.icn.siemens.
	de> <429F3F2B.6090406@enseirb.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <429F3F2B.6090406@enseirb.fr>
Content-Disposition: inline
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

--On Thursday, June 02, 2005 7:17 PM +0200 Hadrien HAMEL <hamel@enseirb.fr> 
wrote:

> There's a step-by-step description about writing a "match" extension here:
>
> http://www.linuxfocus.org/English/February2005/article367.shtml
>
>
> I'm planning on writing another tutorial to help people developping
> extensions for NetFilter :)
> If you have any suggestions, send them to me!

Does the 2.6 kernel need to be built with knowledge of a new module, or can 
the module be built completely outside the kernel tree as one does with 
device drivers? It would be nice if one could experiment with new modules 
using a "stock" kernel. One could then use, for instance, the standard Red 
Hat update systems to stay up to date with the latest kernel and use dkms 
(http://linux.dell.com/files/dkms/dkms.html) to rebuild any custom 
netfilter modules.
