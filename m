From: Alex Samad <alex@samad.com.au>
Subject: Looking for some feedback on iptables manager script
Date: Thu, 27 Aug 2009 11:30:59 +1000
Message-ID: <20090827013058.GD24891@samad.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out11.tpgi.com.au ([220.244.226.121]:36088 "EHLO
	mail11.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754416AbZH0BuA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2009 21:50:00 -0400
Received: from sydrt01.samad.com.au (adsl.samad.com.au [60.241.248.86])
	by mail11.tpgi.com.au (envelope-from alex@samad.com.au) (8.14.3/8.14.3) with ESMTP id n7R1UxVo013856
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2009 11:31:03 +1000
Received: from alex by smtp.samad.com.au with local  (Exim 4.69 #1 (Debian))
	id 1MgTpL-0006rL-0Y
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2009 11:30:59 +1000
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Yylu36WmvOXNoKYn
Content-Type: multipart/mixed; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi


I have a script that i use to manager my iptables rules, been working on
it a bit, basically for my own use.

I was wondering if I could get some feed back on it suggestions, hints
etc



basically it works on a directory structure to hold the chain for
example

/etc/firewall/DB/<PROFILE>/<TABLE>/<CHAIN>/<RULES>

Profile is optional=20
table - corresponds to filter/raw/mangle/nat/...
chain - the default ones and user created ones
rules - are in the format <orderID>Name

where orderID process in

ii<Number>
<number>
aa<number>

all sorted by number

I have used the iptables save and restore to build the changes into a
change file and I use traps to capture any issues and try and put the
tables back to their original state if there is a failure.

I was even thing that i could take the flat files and make then some
sort of tar/bzip/gzip + if you add in some sort of enc + sign you would
end up file a compressed signed file

I have attached the file

thanks

Alex=20

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=makefirewall
Content-Transfer-Encoding: quoted-printable

#!/bin/dash


# Makefirewall scripts
# uses a file/directory DB to store firewall information
# does an atomic add of rules, using iptables-restore


# Creates a WRKFILE in each directory from the rules
# places all the wrkfiles into a single file=20
# and process that with ip[,6]tables-restore
# Any errors will roll back to the original set of rules

#
# Verbose level
# 0x01 - actions
VRBFLG_ACTION=3D0x01
VERBOSEFLG=3D${VERBOSEFLG:-"0"}

# Base directory=20
BASEDIR=3D${BASEDIR:-"/etc/firewall"}

# Echo a string and limit it based on the flags
pstr(){
	if [ $(( $VERBOSEFLG & $VRBFLG_ACTION )) -eq 1 ]
	then
		echo $1
	fi
}



# Allow for different policy sets
[ ! -z "$BASE2DIR" ] && BASEDIR=3D"$BASEDIR/$BASE2DIR"

if [ ! -d $BASEDIR ]
then
	pstr "Base directory doesn't exist ($BASEDIR)"
	exit 1
fi

#
# Database directory
DBDIR=3D${DBDIR:-"./DB"}
DB6DIR=3D${DB6DIR:-"./DB6"}

#
# DB specific variables names are in ./DB/.variables
VARIABLES=3D${VARIABLES:-".variables"}

#
# Defined Names
# Names of all the top level=20
TABLE_NAMES=3D"filter nat mangle"
TABLE_filter=3D"INPUT OUTPUT FORWARD"
TABLE_nat=3D"PREROUTING POSTROUTING OUTPUT"
TABLE_mangle=3D"PREROUTING INPUT OUTPUT FORWARD POSTROUTING"

TABLE6_NAMES=3D"filter mangle"
TABLE6_filter=3D"INPUT OUTPUT FORWARD"
TABLE6_mangle=3D"PREROUTING INPUT OUTPUT FORWARD POSTROUTING"


# Used in BLOCKED chains
BLOCKED=3D'.blocked'
NOTBLOCKED=3D'.notblocked'


# Chain policy's
POLICY_FILE=3D'.policy'
DEFAULT_POLICY=3D${DEFAULT_POLICY:-'DROP'}
DEFAULT_CHAIN=3D'.defaultchain'

# Work file name
WRKFILE=3D${WRKFILE:-'.wrkfile'}

#
# Check for Programs
# Use full paths for the filenames
if [ -x /usr/local/sbin/iptables ]; then
    IPTABLES=3D"/usr/local/sbin/iptables"
else
    IPTABLES=3D"/sbin/iptables"
fi

if [ ! -x $IPTABLES ]
then
	echo "$IPTABLES is not executable"
	exit 1
fi

if [ -x /usr/local/sbin/ip6tables ]; then
    IP6TABLES=3D"/usr/local/sbin/ip6tables"
else
    IP6TABLES=3D"/sbin/ip6tables"
fi

if [ ! -x $IP6TABLES ]
then
	echo "$IP6TABLES is not executable"
	exit 1
fi

if [ -x /usr/local/sbin/iptables-restore ]; then
    IPTABLES_BATCH=3D"/usr/local/sbin/iptables-restore"
else
    IPTABLES_BATCH=3D"/sbin/iptables-restore"
fi

if [ ! -x $IPTABLES_BATCH ]
then
	echo "$IPTABLES_BATCH is not executable"
	exit 1
fi

if [ -x /usr/local/sbin/ip6tables-restore ]; then
    IP6TABLES_BATCH=3D"/usr/local/sbin/ip6tables-restore"
else
    IP6TABLES_BATCH=3D"/sbin/ip6tables-restore"
fi

if [ ! -x $IP6TABLES_BATCH ]
then
	echo "$IP6TABLES_BATCH is not executable"
	exit 1
fi

#if [ $(( $VERBOSEFLG & $VRBFLG_ACTION )) -eq 1 ]
#then
#	IPTABLES_BATCH=3D'>> /tmp/makefirewall.output.debug 2>&1'
#	IP6TABLES_BATCH=3D'>> /tmp/makefirewall.output.debug 2>&1'
#fi

#
# Usage Message
usage (){
	echo $0
	echo "\tcleantables\tClean the iptables tables"
	echo "\tshowtables\tShow the iptables tables"
	echo
	echo "\tsetsecurity\tInsert all the rules (DEFAULT)"
	echo
	echo "\tprocessdirectory\tProcess the current directory"
	echo "\tprocess6directory\tProcess the current directory for ipv6"
	echo
	echo "VARIABLES =3D name of variables file (.variables)"
	echo "WRKFILE =3D name of workfile user (.wrkfile)"
	echo "DEFAULT_POLICY =3D default policy for rules (ACCEPT)"
	echo "DBDIR =3D directory name where all the rules are. (./DB)"
	echo "DB6DIR =3D directory name where all the rules are. (./DB6)"
	echo "BASEDIR =3D directory name program change path to.. (/etc/firewall)"
	echo "BASE2DIR =3D second level into the DB, allows for profiles.. ('')"
	echo

}

#
# Clean iptables
CleanTables(){

	{ # pipe into iptables-restore

		# Flush and set default Policies First
		for MAINDIR in $TABLE_NAMES; do
			echo "*$MAINDIR"
			echo "-F"
			echo "-X"
			SEC_TABLE=3D"TABLE_$MAINDIR"
			eval "set -- \$$SEC_TABLE"
			for SECDIR do
				echo ":$SECDIR $DEFAULT_POLICY [0:0]"
			done
			echo "COMMIT"
		done
	} | $IPTABLES_BATCH

	{ # pipe into iptables-restore

		# Flush and set default Policies First
		for MAINDIR in $TABLE6_NAMES; do
			echo "*$MAINDIR"
			echo "-F"
			echo "-X"
			SEC_TABLE=3D"TABLE6_$MAINDIR"
			eval "set -- \$$SEC_TABLE"
			for SECDIR do
				echo ":$SECDIR $DEFAULT_POLICY [0:0]"
			done
			echo "COMMIT"
		done
	} | $IP6TABLES_BATCH
}

# Show tables
ShowTables(){
	for MAINDIR in $TABLE_NAMES; do
		pstr "\n=3D=3D=3D=3D=3D\nProcessing - table $MAINDIR\n=3D=3D=3D=3D=3D\n"
		$IPTABLES -t $MAINDIR -nvL
	done
# IPv6
	for MAINDIR in $TABLE6_NAMES; do
		pstr "\n=3D=3D=3D=3D=3D\nProcessing - table6 $MAINDIR\n=3D=3D=3D=3D=3D\n"
		$IP6TABLES -t $MAINDIR -nvL
	done
}


#
# Process files in directory
ProcessFiles(){
	# So we can use defined variables we use EVAL

	eval "
		cat <<- EOF
			$(sed "/[[:blank:]]*#/d; /^[[:blank:]]*$/d; s/^\(.*\)#.*$/\\1/; s/^/-A $=
CHAIN /" \
				$(find ii* ! -name '*.dpkg-old' ! -name '*.dpkg-dist' 2>/dev/null | sor=
t ) \
				$(find [0-9]* ! -name '*.dpkg-old' ! -name '*.dpkg-dist' 2>/dev/null | =
sort ) \
				$(find aa* ! -name '*.dpkg-old' ! -name '*.dpkg-dist' 2>/dev/null | sor=
t) \
				< /dev/null )
		EOF
	"
}

# Process BLOCK files=20
ProcessBlockFiles(){
	if [ -f $BLOCKED ]; then
		eval "
			cat <<- EOF
				$(sed "/[[:blank:]]*#/d; /^[[:blank:]]*\$/d; s/^/-I $CHAIN /g; s/\$/ -j=
 DROP/" $BLOCKED )
			EOF
		"

		# if we have TARPIT use it :)
		grep -q TARPIT /proc/net/ip*_tables_targets > /dev/null 2>&1
		if [ $? -eq 0 ]; then
			eval "
				cat <<- EOF
					$(sed "/[[:blank:]]*#/d; /^[[:blank:]]*\$/d; s/^/-I $CHAIN /g; s/\$/ -=
p tcp -j TARPIT/" $BLOCKED )
				EOF
			"
		fi
	fi

	if [ -f $NOTBLOCKED ]; then
		eval "
			cat <<- EOF
				$(sed '/[[:blank:]*#/d; /^[[:blank:]]*$/d; s/^/-I $CHAIN /g; s/$/ -j RE=
TURN/' $NOTBLOCKED )
			EOF
		"
	fi

}


#
# Process a ipv4 directory
ProcessDirectory(){
	set +e

	pstr "Working on $MAINDIR $CHAIN"

	{
		echo "*$MAINDIR"
		echo "-F $CHAIN"
		ProcessFiles

		[ "$CHAIN" =3D "BLOCKED" ] && ProcessBlockFiles


		echo "COMMIT"

	} | tee -a "$IPTNEW" > "$WRKFILE"

	if [ $? -ne 0 ]
	then
		pstr "Current Directory $(pwd)"
		exit 1
	fi
	set -e

}

#
# Process a ipv6 Directory
Process6Directory(){
	set +e

	pstr "Working on $MAINDIR $CHAIN"

	{
		echo "*$MAINDIR"
		echo "-F $CHAIN"

		ProcessFiles

		[ "$CHAIN" =3D "BLOCKED" ] && ProcessBlockFiles

		echo "COMMIT"

	} | tee -a "$IPTNEW6" > "$WRKFILE"

	if [ $? -ne 0 ]
	then
		pstr "Current Directory $(pwd)"
		exit 1
	fi
	set -e

}

#
# Process the files
SetSecurity(){

	# Change into DBDIR
	if [ -d "$BASEDIR/$DBDIR" ]; then
		cd "$BASEDIR/$DBDIR"
	else
		pstr "\nNo Database Directory ($DBDIR)"
		exit 0
	fi
=09

	(
		[ -f ./$VARIABLES ] && . ./$VARIABLES
=09
		for MAINDIR in $TABLE_NAMES; do
=09
			if [ ! -d $MAINDIR ]; then
				pstr "\nNo Default Directory ($MAINDIR)"
				exit 1
			fi
=09
			# Enter table directory
			cd $MAINDIR
=09
			# Find all the directories that we are going to process
			SDIRS=3D"$(find -maxdepth 1 -type d ! -name 'CVS' ! -name '.' -printf '%=
f ' )"
	=09
			# Process the DEFAULT tables and set their default policy
			{
				echo "*$MAINDIR"
				echo "-F"
				echo "-X"
				for CHAIN in $SDIRS; do
					if [ -f $CHAIN/$POLICY_FILE ]
					then
						POLICY=3D$(cat $CHAIN/$POLICY_FILE)
						echo ":$CHAIN $POLICY"
					else
						echo ":$CHAIN -"
					fi
				done
				echo "COMMIT"
			} | tee -a "$IPTNEW" > "$WRKFILE"

			# have to process the Chains first and then the rules
			for CHAIN in $SDIRS; do
				# Enter chain Directory
				cd $CHAIN
=09
				ProcessDirectory
=09
				# Back out chain directory
				cd ..
			done
=09
			# Go back a directory from a table directory
			cd ..
		done

		$IPTABLES_BATCH -n < "$IPTNEW"

	)
	if [ $? -ne 0 ]
	then
		exit 1
	fi

	# Change into DBDIR
	if [ -d "$BASEDIR/$DB6DIR" ]; then
		cd "$BASEDIR/$DB6DIR"
	else
		pstr "\nNo Database 6 Directory ($DB6DIR)"
		exit 0
	fi

	(
		[ -f ./$VARIABLES ] && . ./$VARIABLES
=09
		for MAINDIR in $TABLE6_NAMES; do
=09
			if [ ! -d $MAINDIR ]; then
				pstr "\nNo Default Directory ($MAINDIR)"
				exit 1
			fi
=09
			# Enter table directory
			cd $MAINDIR
=09
			# Find all the directories that we are going to process
			SDIRS=3D"$(find -maxdepth 1 -type d ! -name 'CVS'  ! -name '.' -printf '=
%f ' )"
		=09
			# Process the DEFAULT tables and set their default policy
			{
				echo "*$MAINDIR"
				echo "-F"
				echo "-X"
				for CHAIN in $SDIRS; do
					if [ -f $CHAIN/$POLICY_FILE ]
					then
						POLICY=3D$(cat $CHAIN/$POLICY_FILE)
						echo ":$CHAIN $POLICY"
					else
						echo ":$CHAIN -"
					fi
				done
				echo "COMMIT"
			} | tee -a "$IPTNEW6"  > "$WRKFILE"

=09
			# have to process the Chains first and then the rules for the=20
			for CHAIN in $SDIRS; do
				# Enter chain Directory
				cd $CHAIN
=09
				Process6Directory
=09
				# Back out chain directory
				cd ..
			done
=09
			# Go back a directory from table=20
			cd ..
		done

		$IP6TABLES_BATCH -n < "$IPTNEW6"
	)
	if [ $? -ne 0 ]
	then
		exit 1
	fi
}


#
# Start of the main script

set +e
# Save current state
IPTSAV=3D"$(tempfile)"
IPTSAV6=3D"$(tempfile)"
iptables-save > $IPTSAV 2> /dev/null
ip6tables-save > $IPTSAV6 2> /dev/null

# new workfiles
IPTNEW=3D"$(tempfile)"
IPTNEW6=3D"$(tempfile)"

# on error exit
set -e
trap "$IPTABLES_BATCH -c < $IPTSAV ;  $IP6TABLES_BATCH -c < $IPTSAV6; rm \"=
$IPTSAV\" \"$IPTSAV6\" \"$IPTNEW\" \"$IPTNEW6\" " EXIT

#
# change to lower case
ACTION=3D$( echo $1 | tr A-Z a-z)

# Default action
ACTION=3D${ACTION:-"setsecurity"}

case $ACTION in
	'cleantables')
		CleanTables
		;;
	=09
	'showtables')
		ShowTables
		;;

	'setsecurity')
		SetSecurity
		;;

	'processdirectory')
		CHAIN=3D"$(echo $PWD | sed -n 's/.*\/\([^/]*\)/\1/p')"
		MAINDIR=3D"$(echo $PWD| sed -n 's/.*\/\([^/]*\)\/.*/\1/p')"
		$IPTABLES -t $MAINDIR -F $CHAIN
		echo "Chain [$CHAIN]"
		echo "Maindir [$MAINDIR]"
		echo "Pwd [$oldPwd]"
		echo
		(
			[ -f ../../$VARIABLES ] && . ../../$VARIABLES
			ProcessDirectory
			$IPTABLES_BATCH -n < $IPTNEW
		)
		if [ $? -ne 0 ]
		then
			exit 1
		fi
		;;

	'process6directory')
		CHAIN=3D"$(echo $PWD | sed -n 's/.*\/\([^/]*\)/\1/p')"
		MAINDIR=3D"$(echo $PWD| sed -n 's/.*\/\([^/]*\)\/.*/\1/p')"
		$IP6TABLES -t $MAINDIR -F $CHAIN
		echo "Chain [$CHAIN]"
		echo "Maindir [$MAINDIR]"
		echo "Pwd [$oldPwd]"
		echo
		(
			[ -f ../../$VARIABLES ] && . ../../$VARIABLES
			Process6Directory
			$IP6TABLES_BATCH -n < $IPTNEW6
		)
		if [ $? -ne 0 ]
		then
			exit 1
		fi
		;;

	'-h' | '--help')
		usage
		;;
	*)
		usage
		;;
esac


#
# Everything okay do not retore
trap "-" EXIT
rm "$IPTSAV" "$IPTSAV6" "$IPTNEW" "$IPTNEW6"

# Exit
exit 0




--Dxnq1zWXvFF0Q93v--

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqV4dAACgkQkZz88chpJ2PiwgCfdbBN3VyxsV0BO3wYhQakBpCT
KHsAni/ndDm+VsJU8eCW/aJNN1nFH5P3
=43m2
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
