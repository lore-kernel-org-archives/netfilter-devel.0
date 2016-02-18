From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v7 5/7] openvswitch: Handle NF_REPEAT in
 conntrack action.
Date: Thu, 18 Feb 2016 14:09:19 +0100
Message-ID: <20160218130919.GC2296@salvia>
References: <1454722865-59558-1-git-send-email-jarno@ovn.org>
 <1454722865-59558-6-git-send-email-jarno@ovn.org>
 <CAPWQB7H7oCGS7bLAsArHOUw_N1EtB+pp0W5bdLgojv-od=ejWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jarno Rajahalme <jarno@ovn.org>, netfilter-devel@vger.kernel.org,
	netdev <netdev@vger.kernel.org>, ovs dev <dev@openvswitch.org>
To: Joe Stringer <joe@ovn.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPWQB7H7oCGS7bLAsArHOUw_N1EtB+pp0W5bdLgojv-od=ejWQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Feb 17, 2016 at 02:06:54PM -0800, Joe Stringer wrote:
> On 5 February 2016 at 17:41, Jarno Rajahalme <jarno@ovn.org> wrote:
> > Repeat the nf_conntrack_in() call when it returns NF_REPEAT.  This
> > avoids dropping a SYN packet re-opening an existing TCP connection.
> >
> > Signed-off-by: Jarno Rajahalme <jarno@ovn.org>
> 
> Arguably this is a bugfix.
> 
> Acked-by: Joe Stringer <joe@ovn.org>

You can target this to the nf tree anytime if you want to see this fix
in mainline.
