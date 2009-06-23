From: Anton VG <anton.vazir@gmail.com>
Subject: Ulogd2 beta3 +NFCT - unable to get working
Date: Wed, 24 Jun 2009 04:56:06 +0500
Message-ID: <c4b050a10906231656u53e20855ud5cf5833ca5db7cc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:43365 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZFWX4G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:56:06 -0400
Received: by ewy6 with SMTP id 6so678211ewy.37
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2009 16:56:06 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!

Just spent all night trying to get the %SUBJ% working, but been
unable. There is no any other example in whole internet other than
included into a package and
http://software.inl.fr/trac/wiki/ulogd2/user

Ulogd starts, and tells that everything initialized - but
/var/log/ulogd_syslogemu.log - is always 0 bytes - no logging there.

Maybe I do have to insert any special IPTABLES rule? - But I have not
found any clue what I have to get to feed connection tracking to
ULOGD.

Would anyone please direct me what am I doing wrong?

Examples does not show any nflog gropups and anything else if NFCT is
used. No iptables noticed either.

---------------------------------
ulogd.conf

# Example configuration for ulogd
# $Id$
# Adapted to Debian by Achilleas Kotsis <achille at debian.gr>

[global]
######################################################################
# GLOBAL OPTIONS
######################################################################


# logfile for status messages
logfile="/var/log/ulogd.log"

# loglevel: debug(1), info(3), notice(5), error(7) or fatal(8)
loglevel=1

######################################################################
# PLUGIN OPTIONS
######################################################################

# We have to configure and load all the plugins we want to use

# general rules:
# 1. load the plugins _first_ from the global section
# 2. options for each plugin in seperate section below


plugin="/usr/local/lib/ulogd/ulogd_inppkt_NFLOG.so"
#plugin="/usr/local/lib/ulogd/ulogd_inppkt_ULOG.so"
plugin="/usr/local/lib/ulogd/ulogd_inpflow_NFCT.so"
plugin="/usr/local/lib/ulogd/ulogd_filter_IFINDEX.so"
plugin="/usr/local/lib/ulogd/ulogd_filter_IP2STR.so"
plugin="/usr/local/lib/ulogd/ulogd_filter_IP2BIN.so"
plugin="/usr/local/lib/ulogd/ulogd_filter_PRINTPKT.so"
plugin="/usr/local/lib/ulogd/ulogd_filter_HWHDR.so"
plugin="/usr/local/lib/ulogd/ulogd_filter_PRINTFLOW.so"
#plugin="/usr/local/lib/ulogd/ulogd_filter_MARK.so"
plugin="/usr/local/lib/ulogd/ulogd_output_LOGEMU.so"
plugin="/usr/local/lib/ulogd/ulogd_output_SYSLOG.so"
plugin="/usr/local/lib/ulogd/ulogd_output_OPRINT.so"
#plugin="/usr/local/lib/ulogd/ulogd_output_NACCT.so"
#plugin="/usr/local/lib/ulogd/ulogd_output_PCAP.so"
#plugin="/usr/local/lib/ulogd/ulogd_output_PGSQL.so"
#plugin="/usr/local/lib/ulogd/ulogd_output_MYSQL.so"
#plugin="/usr/local/lib/ulogd/ulogd_output_DBI.so"
plugin="/usr/local/lib/ulogd/ulogd_raw2packet_BASE.so"

stack=ct1:NFCT,ip2str1:IP2STR,print1:PRINTFLOW,emu1:LOGEMU

[ct1]
netlink_socket_buffer_size=2170880
netlink_socket_buffer_maxsize=10854400
hash_enable=0

[emu1]
file="/var/log/ulogd_syslogemu.log"
sync=1
