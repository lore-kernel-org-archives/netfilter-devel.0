From: Zeeshan Ali <zeelists@yahoo.com>
Subject: Re: when/how is the packet forwarded?
Date: Fri, 21 Nov 2003 16:06:02 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031122000602.77268.qmail@web60702.mail.yahoo.com>
References: <20031121185119.516f4729.pcingola@sinectis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20031121185119.516f4729.pcingola@sinectis.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,
  Thanks. You are quite right. ethereal say the IP
Header Checksums was incorrect. I correct this by
re-calculating  the checksum. Now ethereal shows no
sign of errors in the packet. But the routing engine
now seems to be dropping the packets instead of
sending on to my NF_IP_FORWARD hook or the
NF_IP_LOCAL_IN hook. Any more clues? Thanks for
helping me out. Bye.

--- Pablo Cingolani <pcingola@sinectis.com> wrote:
> 
> I think that IP and TCP checksums should be
> recalculated if anything is changed in the 
> packet. I think your packets may be silently
> discarded due to invalid checksum, to see if
> this is the problem, try taking a look at them with
> ethereal (or something like that), it will
> tell you whe checksums are wrong.
> Yours
>    Pablo

__________________________________
Do you Yahoo!?
Protect your identity with Yahoo! Mail AddressGuard
http://antispam.yahoo.com/whatsnewfree
