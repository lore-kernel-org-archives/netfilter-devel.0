From: Vijaya Chandra Vupputuri <vijay@tachyontech.net>
Subject: Re: libipq and ip_queue
Date: Thu, 26 Feb 2004 10:46:54 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1077772240.10512.23.camel@vijay>
References: <20040225041703.GG19291@hserus.net>
	 <Pine.LNX.4.44.0402252238180.32183-100000@filer.marasystems.com>
	 <20040226023731.GE826@hserus.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chandrakanth Chereddi <kanth@hserus.net>
In-Reply-To: <20040226023731.GE826@hserus.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2004-02-26 at 08:07, Chandrakanth Chereddi wrote:
> And one last question, can I set the "policy" on a chain to "QUEUE", I
> wasn't successful in doing that on my machine though.

If it's through libiptc that you are trying to do this, the
TC_SET_POLICY() function makes a check for 'ACCEPT' and 'DROP' and
invalidates any other policy.

The method ip_fw_chk() in ipfwadm_core too checks the policies and goes
with FW_BLOCK if it doesn't have any idea about the policy. May be you
can tinker with the code here.

But the easiest thing that a newbie like me'd do is append a rule at the
end of the chain with what ever target is needed :)

Regards,
Vijaya Chandra Vupputuri,
Tachyon Technologies.
