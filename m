From: Jarek Poplawski <jarkao2@o2.pl>
Subject: Re: adding data fields to netfilter_conntrack / conntrack events
Date: Thu, 24 Aug 2006 12:34:28 +0200
Message-ID: <ecjvad$j7s$1@sea.gmane.org>
References: <echin1$ark$1@sea.gmane.org>
	<24C2A44A-9C91-473D-9784-FD02AB4F2BB1@presinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <24C2A44A-9C91-473D-9784-FD02AB4F2BB1@presinet.com>
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

On 24-08-2006 01:39, Stuart Zilm wrote:
> 
> On 23-Aug-06, at 5:47 AM, Jarek Poplawski wrote:
>> I didn't check this but: did you see this change status
>> function's processing with CTA_NAT_DST (13)?
> 
> Do you mean using CTA_NAT_DST instead of CTA_FOO in the NFA_PUT(...) 
> macro?  CTA_NAT_DST and CTA_FOO are both members of enum ctattr_type - 
> CTA_FOO was added to the end of the enum, just before __CTA_MAX.

I'm very sorry for misunderstanding! You've written it shortly 
and I checked in linux-2.6.18-rc4 only (also shortly) where 13 is 
occupied.

Jarek P.
