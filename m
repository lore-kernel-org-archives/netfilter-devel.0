From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: Re: Comments about IPT_ALIGN
Date: Sun, 26 Jan 2003 12:28:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E33C665.9080106@fugmann.dhs.org>
References: <3E335CB1.9070101@hipac.org> <20030126120159.A3045@linux.karinthy.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Thomas Heinz <creatix@hipac.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Laszlo Valko <valko@linux.karinthy.hu>
In-Reply-To: <20030126120159.A3045@linux.karinthy.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Laszlo Valko wrote:
> On Sun, Jan 26, 2003 at 04:57:37AM +0100, Thomas Heinz wrote:
> 
>>Conclusions:
>>
>>Except for struct tptr both sparc64 and alpha have the same struct
>>alignment and member offsets for all structs.
> 
> 
> This is not too surprising. Both of them are RISC processors with
> strict alignment restrictions. I guess even with a 32bit sparc
> gcc, a 64bit unsigned integer gets aligned to 64bit just to make life
> easier (I'm not sure if there's a 64bit load instruction on 32bit sparc's).

Does this not pose an interresting problem?
What happens if userspace is 32bit, and kernel space is 64bit, when the 
elements of the structure changes size doe to conversion?
Eg:
struct x {
   int a;
   long int b;
   int c;
}

In 32bit userspace, x->a would have offset 0, x->b would have offset 4 
and x->c would have offset 8. But in 64bit kernel space, the long in 
would be 64 bit, and so the offset changes: offset x->a = 0, offset x->b 
  = 4, offset x->c = 12. The structure would then need a special 
conversion from 32 bit userspace to 64 bit kernel space in order for 
values in the struct to be accessed correctly. If this is true, then we 
must only use type with welldifined sizes, that is sizes that does not 
changes from userspace to kernel space.

Please correct me if I'm wrong.

Regards
Anders Fugmann
