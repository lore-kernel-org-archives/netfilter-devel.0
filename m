From: Thomas Heinz <creatix@hipac.org>
Subject: Re: Comments about IPT_ALIGN
Date: Sun, 26 Jan 2003 18:06:32 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E341598.5060907@hipac.org>
References: <3E335CB1.9070101@hipac.org> <20030126120159.A3045@linux.karinthy.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Laszlo Valko <valko@linux.karinthy.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Laszlo

You wrote:
> This is not too surprising. Both of them are RISC processors with
> strict alignment restrictions. I guess even with a 32bit sparc
> gcc, a 64bit unsigned integer gets aligned to 64bit just to make life
> easier

Yes, in fact this is the case. Just take a look at the output of
struct t64 on sparc64 in my first posting.

> Now the problem comes if you have only 32bit integers in the first
> structure and 64bit integers in the second one: you have to either
> use IPT_ALIGN again (which we would like to get rid of), or we
> have to make sure the first structure gets aligned to 64bit.
> We could introduce an extra variablke just for this at the end
> like:
> 
> 	u_int64_t dummy[0];
> }
> 
> Or we could do something like that in netfilter:
> 
> 	struct ipt_entry entries[0];
> }
> 
> This latter version is better if we know what kind structure will follow,
> because it will not increase the size of the structure unnecessarily on
> platforms without alignment restrictions.

Yes, very good point. Another way would be to introduce a new type
for this purpose which is u_int32_t on 32 bit architectures and
u_int64_t on 64 bit architectures or just use long instead if
sizeof(long) always works the expected way.

Anyway this is just a question of personal taste.


Thomas
