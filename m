From: Philip Craig <philipc@snapgear.com>
Subject: Re: [PATCH] big endian patch against netfilter after PPTP NAT pat
 ch
Date: Thu, 06 Feb 2003 10:09:32 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E41A7BC.20209@snapgear.com>
References: <771F217D7A4AF84494632457889470A412D77E@bcmsg011.corp.ads>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Poon <Chris.Poon@TELUS.COM>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Chris Poon wrote:
> Padding was the first way I think of how to solve it, but now that I look at it
> again, the problem is actually the size assumption of the mask - almost
> all helpers assumes a 16 bit mask. The PPTP patch breaks that assumption,
> and because of the nature of the patches, I wouldn't have modified all the
> places where the mask is filled out. Maybe the correct way is solve this is to
> make the field size change permanent in ip_conntrack_manip_proto and
> ip_conntrack_tuple, and change all the places that fill out the mask to use
> the right sized mask instead of 0xffff, which happens to break the big-endian
> machines but not the little endian machines. What do you think?

No, the masks the helpers currently use are the correct mask
for what they need.  For example, the ftp helper wants the
mask to cover the IP address and the TCP port.  The TCP port
is still only 16 bits regardless of what changes are made to
the structure, so the mask must still be 0xffff.

The problem is that they are storing the mask in the u.all
member of the union, rather than the specific member that
they are interested in.  So if the total size of union
changes, the mask getting stored will no longer match up
with the appropriate member, depending on endianness and
padding.

The proper fix is what Harald said: zero out the structure, and
store the mask in the specific member, rather than u.all.
Once they are fixed properly, they will also work for any
future changes to the tuple structure.

Paul Mielke posted a patch a few weeks ago that fixed the ftp
helper and the SO_ORIGINAL_DST ioctl.

-- 
Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
SnapGear - Custom Embedded Solutions and Security Appliances
