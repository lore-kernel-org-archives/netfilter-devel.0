From: Philip Craig <philipc@snapgear.com>
Subject: Re: PPTP connection tracking
Date: Tue, 03 Dec 2002 13:31:38 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DEC259A.5050401@snapgear.com>
References: <Pine.LNX.4.44.0212022159080.16692-200000@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ilguiz Latypov <ilguiz@nit.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ilguiz Latypov wrote:
> I changed pptpctrl.c to issue pseudo-unique Call ID's for every incoming
> TCP connection.  Each connection spawns a process.
> 
> Is this modification reasonable?  I will submit it to pptpd maintainer as
> well.

I came across this problem in my testing as well.  Assigning
a random ID is not really correct, but it's the easiest thing
to do to get it working.  It's better than always using 0 at
least.

Regards,
Phil

-- 
Philip Craig     Software Engineer     http://www.SnapGear.com
philipc@snapgear.com  Ph: +61 7 3435 2821  Fx: +61 7 3891 3630
SnapGear  -  Custom Embedded Solutions and Security Appliances
