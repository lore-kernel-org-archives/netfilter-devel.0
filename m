From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: getting PID and task name from sk_buff
Date: Thu, 24 Feb 2005 08:22:29 -0500
Message-ID: <876ef97a050224052244efa6f3@mail.gmail.com>
References: <DEEDILHNOLKHPLJKLINBOEFHJMAC.alan@stead.com>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: alan@stead.com
In-Reply-To: <DEEDILHNOLKHPLJKLINBOEFHJMAC.alan@stead.com>
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

On Wed, 23 Feb 2005 22:17:01 -0800, Alan Stead <alan@stead.com> wrote:
> Any suggestions on a better way to do this?
> I am trying to track network traffic based on the process name and the
> process ID.

Check out how the ipt_owner match module does it. However, I think
that this is not perfect, either. Maybe someone else has a better
idea?

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
